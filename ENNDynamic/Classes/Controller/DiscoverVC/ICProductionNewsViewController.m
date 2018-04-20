//
//  ICAddDynamicViewController.m
//  ICome
//
//  Created by zhangrongwu on 16/4/18.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICProductionNewsViewController.h"
//#import "ICPhotoPickerManager.h"
#import "ICUploadPhotoCollectionViewCell.h"
#import "ICMediaManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+Extension.h"
#import "MBProgressHUD.h"
#import "ZacharyPlayManager.h"
#import "ICAVPlayer.h"
#import "ICProductionModel.h"
#import "ICDynamicNetworkManager.h"
#define  drafts [NSString stringWithFormat:@"proNews_%@", [ICUser currentUser].eId]
#define  imageSize  [UIScreen mainScreen].bounds.size.width > 320 ? 97 : 80

@interface ICProductionNewsViewController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, ICAVPlayerDelegate, ICUploadPhotoCollectionViewCellDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *placeholderLabel;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIImageView *videoImageView;
@property (nonatomic, strong)NSString *videoImgKey;
@property (nonatomic, assign)float time;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong)UIButton *rightButton;

@property (nonatomic, assign) long identify;
@property (nonatomic, strong)NSMutableArray *proList;
@property (nonatomic, assign)NSInteger tempIndex;
@property (nonatomic, assign)NSInteger sendImageCount;


@end

@implementation ICProductionNewsViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setConfig];
    [self setNav];
    [self initNotificationCenter];
    [self setUI];
    [self setData];
}

#pragma mark - UITableViewDelegate

#pragma mark - CustomDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textView resignFirstResponder];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.proList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ICUploadPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ICUploadPhotoCollectionViewCell" forIndexPath:indexPath];
    ICProductionModel *model = [self.proList objectAtIndex:indexPath.row];
    cell.imageView.image = model.image;
    cell.delegate = self;
    if (model.Plus) {
        cell.canclelBtn.hidden = YES;
    } else {
        cell.canclelBtn.hidden = NO;
    }
    if (model.hide) {
        cell.userInteractionEnabled = NO;
        cell.imageView.hidden = YES;
    } else {
        cell.userInteractionEnabled = YES;
        cell.imageView.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.textView resignFirstResponder];
    ICProductionModel *model = [self.proList objectAtIndex:indexPath.row];
//    if (model.Plus) {
//        [[ICPhotoPickerManager shareInstace] showActionSheetInView:self.view maxCount:9 - self.tempIndex fromController:self completionBlock:^(NSMutableArray *imageArray) {
//            // 上传服务器
//            [self sendImageWithImageArray:imageArray];
//            [self setUI];
//            [self.collectionView reloadData];
//        }];
//    }
    //图片选择

}
- (void)textViewDidChange:(UITextView *)textView {

    if ((self.newsType == NSourceTypeText || self.tempIndex == 0) && self.newsType != NSourceTypeVideo) {
        if ([self isEmpty:textView.text]) {
            self.placeholderLabel.hidden = (textView.text.length>0)?YES:NO;
            [self setRightBarBtnEnabled:NO];
        }else
        {
            self.placeholderLabel.hidden = YES;
            [self setRightBarBtnEnabled:YES];
        }
    }else if (self.newsType == NSourceTypeVideo || self.tempIndex != 0) {
        if ([self isEmpty:textView.text]) {
            self.placeholderLabel.hidden = (textView.text.length>0)?YES:NO;
        }else
        {
            self.placeholderLabel.hidden = YES;
        }
    }
}


- (BOOL)isEmpty:(NSString *)str {
    
    if (!str) {
        return YES;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (void)setRightBarBtnEnabled:(BOOL)enabled
{
    self.navigationItem.rightBarButtonItem.enabled = enabled;
    [_rightButton setTitleColor:enabled?DEFAULT_SUBJECT_COLOR:[UIColor colorWithHexString:@"#B0B0B0"] forState:UIControlStateNormal];
}

-(void)closePlayerViewAction {
    [self.textView becomeFirstResponder];
}

-(void)didClickCanclelButtonInCell:(ICUploadPhotoCollectionViewCell *)cell {
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    // 移除数据
    [self.proList removeObjectAtIndex:indexPath.row];
    self.tempIndex--;
    if (self.proList.count != 10) {
        ICProductionModel *lastPro = [self.proList lastObject];
        lastPro.hide = NO;
        [self.collectionView reloadData];
    }
    if (self.proList.count < 10) {
        [[NSUserDefaults standardUserDefaults] setFloat:self.tempIndex forKey:@"FlowMaxSeletedNumber"];
    }
    
    if (self.tempIndex == 0) {
        
        if ([self isEmpty:self.textView.text]) {
            self.placeholderLabel.hidden = (self.textView.text.length>0)?YES:NO;
            [self setRightBarBtnEnabled:NO];
        }else
        {
            self.placeholderLabel.hidden = YES;
            [self setRightBarBtnEnabled:YES];
        }
    }
}

#pragma mark - event response
- (void)rightButtonAction:(UIButton *)sender {
    
    //self.navigationItem.rightBarButtonItem.enabled  = NO;
    //  视频 图片
    if (self.newsType != 0) {
        if (self.newsType == 3) {// 视频
            ICProductionModel *pro = [self.proList firstObject];
            if ([ICTools stringEmpty:self.videoImgKey]||[ICTools stringEmpty:pro.videoKey]) {
                [MBProgressHUD showError:@"视频处理中..." toView:self.view];
                return;
            }
        } else {
            // 图片
        }
        [self sendMessageToDiscover];
    } else {
        if (![ICTools stringEmpty:self.textView.text] && self.textView.text.length > 0) {
            [self sendMessageToDiscover];
        } else {
            ALERT(@"请输入内容");
            //self.navigationItem.rightBarButtonItem.enabled  = YES;
        }
    }
}

- (void)backClick {
    if (self.newsType == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.textView.text forKey:drafts];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - private methods

//Repeat play
-(void)reloadStart {
    __weak typeof(self) weakSelf=self;
    [[ZacharyPlayManager sharedInstance] startWithLocalPath:self.videoPath WithVideoBlock:^(UIImage *imageData, NSString *filePath,CGImageRef tpImage) {
        if ([filePath isEqualToString:weakSelf.videoPath]) {
            weakSelf.videoImageView.image = imageData;
        }
    }];
    
    [[ZacharyPlayManager sharedInstance] reloadVideo:^(NSString *filePath) {
        MAIN(^{
            if ([filePath isEqualToString:weakSelf.videoPath]) {
                [weakSelf reloadStart];
            }
        });
    } withFile:self.videoPath];
}

-(void)stopVideo {
    [[ZacharyPlayManager sharedInstance] cancelVideo:self.videoPath];
}

- (void)setConfig {
    self.identify = 0;
    self.tempIndex = 0;
    [[NSUserDefaults standardUserDefaults] setFloat:0.0 forKey:@"FlowMaxSeletedNumber"];
}
// 设置页面布局
- (void)setUI {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.videoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-10);
        if (![ICTools stringEmpty:self.videoPath]) {
            CGFloat width = videoImageView_Width;
            CGFloat height = videoImageView_Width * self.videoImageView.image.size.height / self.videoImageView.image.size.width;
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            
            self.videoImageView.width = width;
            self.videoImageView.height = height;
        } else {
            make.width.mas_equalTo(0);
        }
    }];
    
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.videoImageView.mas_left);
        make.height.mas_equalTo(150);
    }];
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(300);
    }];
    
    self.activityIndicator.center = CGPointMake(self.videoImageView.width / 2, self.videoImageView.height / 2);
}
// 设置navigation
- (void)setNav {
    self.title = NSLocalizedString(@"dynamic", nil);
//    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)]];
//    if (self.newsType == 0) {
//        [self.navigationItem.rightBarButtonItem setTintColor:DEFAULT_SUBJECT_COLOR];
//        self.navigationItem.rightBarButtonItem.enabled = NO;
//    }
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44., 44.);
    [_rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithHexString:@"#B0B0B0"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.titleLabel.font = ICFont(15);
    _rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"App_back_blue" itemType:UIBarButtonItemTypeLeft target:self action:@selector(backClick)];
}

- (PickSourceType)getSourceType {
    if (self.newsType == 1) {
        return sourceTypeCamera;
    } else if (self.newsType == 2) {
        return sourceTypePhotoLibrary;
    }
    return sourceTypeCamera;
}

- (void)getData {
    //图片选择

//    [[ICPhotoPickerManager shareInstace] selectPhotoWithPickSourceType:[self getSourceType] maxCount:9 fromController:self completionBlock:^(NSMutableArray *imageArray) {
//        if (imageArray.count == 0) {
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            // 上传服务器
//            [self sendImageWithImageArray:imageArray];
//            [self setUI];
//            [self.collectionView reloadData];
//        }
//    }];
}

- (void)setData {
    if (self.newsType == 1 || self.newsType == 2) {
        [self getData];
        ICProductionModel *model = [[ICProductionModel alloc] init];
        model.picName = @"icon_discover_add";
        model.hide = NO;
        model.Plus = YES;
        model.image = [UIImage imageNamed:model.picName];
        [self.proList addObject:model];
    } else if (self.newsType == 3) {
        [self reloadStart];
        NSData *data = [NSData dataWithContentsOfFile:self.videoPath];
        // 发送视频
        WEAKSELF;
        self.activityIndicator.hidden = NO;
        NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSString currentName]];
        [[ICDynamicNetworkManager sharedInstance] sendMedia:data mediaName:videoName success:^(id object) {
            if (object) {
                ICProductionModel *model = [[ICProductionModel alloc] init];
                model.videoKey = [object objectForKey:@"data"];
                [self.proList addObject:model];
                
                [weakSelf.textView becomeFirstResponder];
                weakSelf.activityIndicator.hidden = YES;
                [weakSelf.activityIndicator removeFromSuperview];
                
                // 本地更名操作
                NSFileManager *manager = [NSFileManager defaultManager];
                NSArray *pathList = [self.videoPath componentsSeparatedByString:@"/"];
                NSMutableArray *mutaList = [[NSMutableArray alloc] initWithArray:pathList];
                [mutaList replaceObjectAtIndex:pathList.count - 1 withObject:[NSString stringWithFormat:@"%@.mp4",[object objectForKey:@"data"]]];
                
                NSMutableString *newPath = [[NSMutableString alloc] init];
                for (int index = 0; index < mutaList.count; index++) {
                    [newPath appendString:@"/"];
                    [newPath appendString:mutaList[index]];
                }
                [manager moveItemAtPath:self.videoPath toPath:newPath error:nil];
                self.videoPath = [newPath mutableCopy];
                [self reloadStart];
            }
        } failure:^(NSError *error) {
            
        }];
        
        // 视频时长
        self.time = 0.0;
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.videoPath] options:nil];
        CMTime videoDuration = urlAsset.duration;
        self.time = CMTimeGetSeconds(videoDuration);
        
        // 发送第一帧图片
        UIImage *image = [UIImage videoFramerateWithPath:self.videoPath];
        UIImage *image_ = [UIImage fixOrientation:image];
        NSData *imageData = UIImageJPEGRepresentation(image_, 0.5);// 0.3-0.7之间
        NSString *imageName = [NSString stringWithFormat:@"%@.jpeg", [NSString currentName]];
        [[ICDynamicNetworkManager sharedInstance] sendImage:imageData imgName:imageName progress:^(NSProgress *progress) {
        } success:^(id object) {
            if (object) {
                weakSelf.videoImgKey = [object objectForKey:@"data"];
                [weakSelf setRightBarBtnEnabled:YES];
            }
        } failure:^(NSError *error) {
            
        }];
    } else {
        [self.textView becomeFirstResponder];
    }
}


- (NSMutableArray *)getMediaParam {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    if ([[self mediaType] isEqualToString:TypeDyVideo]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        ICProductionModel *model = [self.proList firstObject];
        [dict setValue:model.videoKey forKey:@"k"]; // 视频key
        [dict setValue:self.videoImgKey == nil ? @"":self.videoImgKey forKey:@"id"];// 图片key
        [dict setValue:@(self.time * 1000) forKey:@"t"];// 时长
        UIImage *image = [UIImage videoFramerateWithPath:self.videoPath];
        [dict setValue:@(image.size.width) forKey:@"w"];// 宽
        [dict setValue:@(image.size.height) forKey:@"h"];// 高
        [arr addObject:dict];
    } else if ([[self mediaType] isEqualToString:TypeDyPic]) {// 单图
        [arr addObject:[self getImageParamIndex:0]];
    } else if ([[self mediaType] isEqualToString:TypeDyMPic]) { // 多图
        for (int index = 0; index < self.proList.count-1; index++) {
            [arr addObject:[self getImageParamIndex:index]];
        }
    }
    return arr;
}

- (NSMutableDictionary *)getImageParamIndex:(NSInteger)index {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    ICProductionModel *model = self.proList[index];
    UIImage *image = model.image;
    [dict setValue:model.picKey forKey:@"k"]; // 视频key
    [dict setValue:@(image.size.width) forKey:@"w"];// 宽
    [dict setValue:@(image.size.height) forKey:@"h"];// 高
    return dict;
}

- (void)sendMessageToDiscover {
    // 上传media 获取 mediakeys
    NSString *content = self.textView.text == nil ? @"" : self.textView.text;
    NSDictionary *param = @{@"eId":[ICUser currentUser].eId,
                            @"eName":[ICUser currentUser].eName,
                            @"content":content,
                            @"mediaType":[self mediaType],
                            @"mediaKeys":[self getMediaParam]};
    NSLog(@"%@", param);
    [MBProgressHUD showMessage:@"发送中..." toView:self.view];
    WEAKSELF;
    [[ICDynamICDynamicNetworkManager sharedInstance] requestAddFindWithParam:param success:^(id object) {
        [MBProgressHUD showSuccess:@"发送成功"];
        //self.navigationItem.rightBarButtonItem.enabled  = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUpdateDiscoverNews object:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
        if (self.newsType == 0) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:drafts];
        }
        
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"发送失败"];
        //self.navigationItem.rightBarButtonItem.enabled  = YES;
    }];
}

// 分部 上传图片
- (void)sendImageWithImageArray:(NSArray *)imageArray {
    self.sendImageCount = 0;
    WEAKSELF;
    [MBProgressHUD showMessage:@"处理中..." toView:self.view];
    @autoreleasepool {
        [imageArray enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *image_ = [UIImage fixOrientation:image];
            NSData *imageData = UIImageJPEGRepresentation(image_, 0.5);// 0.3-0.7之间
            NSString *imageName = [NSString stringWithFormat:@"%@_%ld.jpeg", [NSString currentName], self.identify++];
            ICProductionModel *model = [[ICProductionModel alloc] init];
            model.picName = imageName;
            model.image = image;
            model.hide = NO;
            model.Plus = NO;
            [self.proList insertObject:model atIndex:self.proList.count-1];
            self.tempIndex++;
            if (self.proList.count == 10) {
                ICProductionModel *lastPro = [self.proList lastObject];
                lastPro.hide = YES;
            }
            [[ICDynamicNetworkManager sharedInstance] sendImage:imageData imgName:imageName progress:^(NSProgress *progress) {
            } success:^(id object) {
                if (object) {
                    [weakSelf setRightBarBtnEnabled:YES];
                    self.sendImageCount++;
                    for (ICProductionModel *model in self.proList) {
                        if ([model.picName isEqualToString:imageName]) {
                            model.picKey = [object objectForKey:@"data"];
                        }
                    }
//                    ICProductionModel *pro = [self.proList objectAtIndex:idx];
//                    pro.picKey = [object objectForKey:@"data"];
//                    NSLog(@" ----------- %@", pro.picKey);
                    if (self.sendImageCount == imageArray.count) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }];
    }
}

- (NSString *)mediaType {
    NSInteger index = self.proList.count;
    if ([ICTools stringEmpty:self.videoPath] && (self.newsType == 1 || self.newsType == 2)) {
        ICProductionModel *lastPro = [self.proList lastObject];
        if (lastPro.Plus) {
            index--;
        }
    }
    
    switch (index) {
        case 0:
            return TypeDyText;
            break;
        case 1:
            if (self.newsType == 3) { // 视频
                return TypeDyVideo;
            } else {
                return TypeDyPic;
            }
            break;
        default:
            return TypeDyMPic;
            break;
    }
}


- (void)initNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backClick) name:NotificationProductionVcBack object:nil];
}

-(UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(App_Frame_Width, APP_Frame_Height);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView =[[UITextView alloc] init];
        _textView.font = ICFont(14);
        _textView.delegate = self;
        [self.scrollView addSubview:_textView];
        NSString *draftString = @"";
        if (self.newsType == 0) {
            draftString = [[NSUserDefaults standardUserDefaults] objectForKey:drafts];
        }
        
        if ([self isEmpty:draftString]) {
            self.placeholderLabel.hidden = NO;
            [self setRightBarBtnEnabled:NO];
        }else
        {
            _textView.text = draftString;
            self.placeholderLabel.hidden = YES;
            [self setRightBarBtnEnabled:YES];
        }
        _textView.showsVerticalScrollIndicator = NO;
    }
    return _textView;
}

-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(imageSize, imageSize);
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        [self.scrollView addSubview:_collectionView];
        
        [_collectionView registerClass:[ICUploadPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"ICUploadPhotoCollectionViewCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

-(UIImageView *)videoImageView {
    if (!_videoImageView) {
        _videoImageView = [[UIImageView alloc] init];
        if (![ICTools stringEmpty:self.videoPath]) {
            UIImage *image = [UIImage videoFramerateWithPath:self.videoPath];
            _videoImageView.image = image;
            WEAKSELF;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
                NSMutableArray *items = [[NSMutableArray alloc] init];
                ICAVPlayerGroupItem *item = [ICAVPlayerGroupItem new];
                item.thumbView = self.videoImageView;
                item.videoPath = self.videoPath;
                [items addObject:item];
                
                ICAVPlayer *player = [[ICAVPlayer alloc] initWithGroupItems:items];
                player.delegate = self;
                [player presentFromVideoView:self.videoImageView toContainer:App_RootCtr.view animated:YES completion:^{
                    [weakSelf.textView resignFirstResponder];
                }];
            }];
            [_videoImageView addGestureRecognizer:tap];
        }
        _videoImageView.userInteractionEnabled = YES;
        [self.view addSubview:_videoImageView];
    }
    return _videoImageView;
}

-(UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.videoImageView addSubview:_activityIndicator];
        _activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [_activityIndicator startAnimating];
        _activityIndicator.hidden = YES;
    }
    return _activityIndicator;
}

-(UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(3, 6, 150, 20)];
        _placeholderLabel.text = @"这一刻您的想法...";
        _placeholderLabel.enabled = NO;
        _placeholderLabel.font = ICFont(14);
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.hidden = YES;
        [self.textView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}
-(NSMutableArray *)proList {
    if (!_proList) {
        _proList = [[NSMutableArray alloc] init];
    }
    return _proList;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

//
//  ICShareDiscProController.m
//  ICome
//
//  Created by zhangrongwu on 16/8/28.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICShareDiscProController.h"
//#import "ICPhotoPickerManager.h"
#import "ICUploadPhotoCollectionViewCell.h"
#import "ICMediaManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIImage+Extension.h"
#import "MBProgressHUD.h"
#import "ZacharyPlayManager.h"
#import "ICAVPlayer.h"
#import "ICProductionModel.h"
#import "ICWebPageView.h"
#import "ICDynamicNetworkManager.h"

#define  imageSize  [UIScreen mainScreen].bounds.size.width > 320 ? 97 : 80

@interface ICShareDiscProController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, ICAVPlayerDelegate, ICUploadPhotoCollectionViewCellDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UILabel *placeholderLabel;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)ICWebPageView *webPageView;
@property (nonatomic, strong)UIImageView *videoImageView;
@property (nonatomic, strong)NSString *videoImgKey;
@property (nonatomic, strong)NSString *picUrlKey;
@property (nonatomic, assign)float time;
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong)UIButton *rightButton;

@property (nonatomic, assign) long identify;
@property (nonatomic, strong)NSMutableArray *proList;
@property (nonatomic, assign)NSInteger tempIndex;
@property (nonatomic, assign)NSInteger sendImageCount;

@property (nonatomic, strong)NSString *videoPath;

@end

@implementation ICShareDiscProController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setConfig];
    [self setNav];
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
    ICProductionModel *model = [self.proList objectAtIndex:indexPath.row];
    if (model.Plus) {
        [[NSUserDefaults standardUserDefaults] setFloat:self.tempIndex forKey:@"FlowMaxSeletedNumber"];
        //图片选择
//        [[ICPhotoPickerManager shareInstace] showActionSheetInView:self.view maxCount:9 fromController:self completionBlock:^(NSMutableArray *imageArray) {
//            // 上传服务器
//            [self sendImageList:imageArray];
//            [self setUI];
//            [self.collectionView reloadData];
//        }];
    }
}
- (void)textViewDidChange:(UITextView *)textView {
    NSString *tempStr = @"\n";
    BOOL isAllEnter = YES;
    for (int i = 0; i<textView.text.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *temp = [textView.text substringWithRange:range];
        if (![temp isEqualToString:tempStr]) {
            isAllEnter = NO;
            break;
        }
    }
    if (isAllEnter) {
        self.placeholderLabel.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.navigationItem.rightBarButtonItem setTintColor:DEFAULT_SUBJECT_COLOR];
        return;
    }
    
    self.placeholderLabel.hidden = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
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
}

#pragma mark - event response
- (void)rightButtonAction:(UIButton *)sender {
    if (self.shareObject.mediaType == ICMediaType_Text) {
        if (![ICTools stringEmpty:self.textView.text] && self.textView.text.length > 0) {
            [self sendMessageToDiscover];
        } else {
            ALERT(@"请输入内容");
        }
    } else {
        if (self.shareObject.mediaType == ICMediaType_Video) {// 视频
            ICProductionModel *pro = [self.proList firstObject];
            if ([ICTools stringEmpty:self.videoImgKey]||[ICTools stringEmpty:pro.videoKey]) {
                [MBProgressHUD showError:@"视频处理中..." toView:self.view];
                return;
            }
        } else if (self.shareObject.mediaType == ICMediaType_PicURL) {
            if ([ICTools stringEmpty:self.picUrlKey]) {
                [MBProgressHUD showError:@"处理中..." toView:self.view];
                return;
            }
        } else {
            // 图片 不需要处理
        }
        [self sendMessageToDiscover];
    }
}

- (void)backClick {
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
    
    [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(150);
    }];
    
    if (self.shareObject.mediaType == ICMediaType_Image) {
        [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.mas_equalTo(300);
        }];
    } else if (self.shareObject.mediaType == ICMediaType_PicURL) {
        [self.webPageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.mas_equalTo(80);
        }];
    } else if (self.shareObject.mediaType == ICMediaType_Video) {
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
    }
    
    self.activityIndicator.center = CGPointMake(self.videoImageView.width / 2, self.videoImageView.height / 2);
}
// 设置navigation
- (void)setNav {
    self.title = NSLocalizedString(@"dynamic", nil);
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)]];
    
    if (self.shareObject.mediaType == ICMediaType_Text) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    } else {
        [self.navigationItem.rightBarButtonItem setTintColor:DEFAULT_SUBJECT_COLOR];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
   // [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"App_back_blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"App_back_blue" itemType:UIBarButtonItemTypeLeft target:self action:@selector(backClick)];
}

- (void)getImageMessage {
    NSMutableArray *imageList = [[NSMutableArray alloc] init];
    [imageList addObject:self.shareObject.imageObject.image];
    [self sendImageList:imageList];
    [self setUI];
    [self.collectionView reloadData];
}

- (void)setData {
    WEAKSELF;
    if (self.shareObject.mediaType == ICMediaType_Image) {
        [self getImageMessage];
        ICProductionModel *model = [[ICProductionModel alloc] init];
        model.picName = @"icon_discover_add";
        model.hide = NO;
        model.Plus = YES;
        model.image = [UIImage imageNamed:model.picName];
        [self.proList addObject:model];
    } else if (self.shareObject.mediaType == ICMediaType_Video) {
        //        [self save]
        [self reloadStart];
        NSData *data = [NSData dataWithContentsOfFile:self.videoPath];
        // 发送视频
        NSString *videoName = [NSString stringWithFormat:@"%@.mp4", [NSString currentName]];
        self.activityIndicator.hidden = NO;
        [[ICNetworkManager sharedInstance] sendMedia:data mediaName:videoName success:^(id object) {
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
        self.time = 0.0f;
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:self.videoPath] options:nil];
        CMTime videoDuration = urlAsset.duration;
        self.time = CMTimeGetSeconds(videoDuration);
        
        // 发送第一帧图片
        UIImage *image = [UIImage videoFramerateWithPath:self.videoPath];
        UIImage *image_ = [UIImage fixOrientation:image];
        NSData *imageData = UIImageJPEGRepresentation(image_, 0.5);// 0.3-0.7之间
        NSString *imageName = [NSString stringWithFormat:@"%@.jpeg", [NSString currentName]];
        [[ICNetworkManager sharedInstance] sendImage:imageData imgName:imageName progress:^(NSProgress *progress) {
        } success:^(id object) {
            if (object) {
                weakSelf.videoImgKey = [object objectForKey:@"data"];
            }
        } failure:^(NSError *error) {
        }];
    } else if (self.shareObject.mediaType == ICMediaType_PicURL) {
        NSData *imageData = self.shareObject.message.thumbData;
        NSString *imageName = [NSString stringWithFormat:@"%@.jpeg", [NSString currentName]];
        [[ICNetworkManager sharedInstance] sendImage:imageData imgName:imageName progress:^(NSProgress *progress) {
        } success:^(id object) {
            if (object) {
                weakSelf.picUrlKey = [object objectForKey:@"data"];
            }
        } failure:^(NSError *error) {
            
        }];
        [self.textView becomeFirstResponder];
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
    } else if ([[self mediaType] isEqualToString:TypeDyPicURL]) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:self.picUrlKey forKey:@"k"]; // 视频key
        [dict setValue:self.shareObject.message.title forKey:@"title"];// 宽
        [dict setValue:self.shareObject.webPageObject.webpageUrl forKey:@"u"];// url
        [dict setValue:self.shareObject.message.displayName forKey:@"f"];// from
        [arr addObject:dict];
    }
    return arr;
}

- (NSMutableDictionary *)getImageParamIndex:(NSInteger)index {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    ICProductionModel *model = self.proList[index];
    UIImage *image = model.image;
    [dict setValue:model.picKey forKey:@"k"]; // key
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
    [MBProgressHUD showMessage:@"发送中..." toView:self.view];
    
    [[ICDynamicNetworkManager sharedInstance] requestAddFindWithParam:param success:^(id object) {
        [self.navigationController popViewControllerAnimated:YES];
        // 成功后回调
        [ICReceiveShareObject callBackAppType:ICCallBackShare callBackScheme:self.shareObject.message.urlSchemes ErrCode:IComSuccess errorStr:@"分享成功"];
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}

// 分部 上传图片
- (void)sendImageList:(NSMutableArray *)imageList {
    self.sendImageCount = 0;
    [MBProgressHUD showMessage:@"处理中..." toView:self.view];
    @autoreleasepool {
        [imageList enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
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
            [[ICNetworkManager sharedInstance] sendImage:imageData imgName:imageName progress:^(NSProgress *progress) {
            } success:^(id object) {
                if (object) {
                    self.sendImageCount++;
                    ICProductionModel *pro = [self.proList objectAtIndex:idx];
                    
                    pro.picKey = [object objectForKey:@"data"];
                    
                    if (self.sendImageCount == imageList.count) {
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
    if ([ICTools stringEmpty:self.videoPath] && self.shareObject.mediaType == ICMediaType_Image) {
        ICProductionModel *lastPro = [self.proList lastObject];
        if (lastPro.Plus) {
            index--;
        }
    }
    
    switch (self.shareObject.mediaType) {
        case ICMediaType_Text:{
            return TypeDyText;
        }
            break;
        case ICMediaType_Image:{
            if (index == 1) {
                return TypeDyPic; // 单图
            } else {
                return TypeDyMPic; // 多图
            }
        }
            break;
        case ICMediaType_Video:{
            return TypeDyVideo;
        }
            break;
        case ICMediaType_File:{
            
        }
            break;
        case ICMediaType_PicURL:{
            return TypeDyPicURL;
        }
            break;
        default:
            break;
    }
    return TypeDyText;
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
        if (self.shareObject.textObject) {
            _textView.text = self.shareObject.textObject.text;
        }
        [self.scrollView addSubview:_textView];
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
        //        [self.textView addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}
-(NSMutableArray *)proList {
    if (!_proList) {
        _proList = [[NSMutableArray alloc] init];
    }
    return _proList;
}

-(ICWebPageView *)webPageView {
    if (!_webPageView) {
        _webPageView = [[ICWebPageView alloc] init];
        _webPageView.headImageView.image = [UIImage imageWithData:self.shareObject.message.thumbData];
        _webPageView.titleLabel.text = self.shareObject.message.title;
        _webPageView.descLabel.text = self.shareObject.message.desc;
        _webPageView.url = self.shareObject.webPageObject.webpageUrl;
        WEAKSELF;
        _webPageView.webPageAction = ^(NSString *url) {
            [weakSelf pushCustomViewControllerURL:url fromViewController:weakSelf animated:YES];
        };
        [self.scrollView addSubview:_webPageView];
    }
    return _webPageView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

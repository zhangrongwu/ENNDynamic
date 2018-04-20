//
//  ICPhotoContainerView.m
//  ICome
//
//  Created by zhangrongwu on 16/4/13.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICPicContainerView.h"
#import "YYControl.h"
#import "ICPicModel.h"
#import "EnnDynamicHeader.h"
#define kWBCellPadding 15       // cell padding
#define kWBCellPaddingPic 3     // cell 多张图片中间留白
#define kWBCellPicHeight App_Frame_Width > 320 ? 90 : 75       // cell padding

@interface ICPicContainerView() {
    UIMenuItem * _collectMenuItem;
}

@property (nonatomic, strong)NSArray *imageList;

@property (nonatomic, assign)int longPressIndex;


@end
@implementation ICPicContainerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatImageViews];
    }
    return self;
}

/*********************************- YYControl -**************************************/
-(void)setModel:(ICDiscoverTableViewCellViewModel *)model {
    _model = model;
    [self layoutPicsWithStatus:model];
    [self setImageViewFrame];
}
// 创建图片控件
- (void)creatImageViews {
    __weak __typeof(&*self)weakSelf = self;
    NSMutableArray *picViews = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        YYControl *imageView = [YYControl new];
        imageView.size = CGSizeMake(90, 90);
        imageView.hidden = YES;
        imageView.clipsToBounds = YES;
        imageView.exclusiveTouch = YES;
        imageView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
            if (self.cellImageTapAction) {
                if (state == YYGestureRecognizerStateEnded) {
                    UITouch *touch = touches.anyObject;
                    CGPoint p = [touch locationInView:view];
                    if (CGRectContainsPoint(view.bounds, p)) {
                        weakSelf.cellImageTapAction(i);
                    }
                }
            }
        };
        
        [picViews addObject:imageView];
        [self addSubview:imageView];
        
        // 长按
        imageView.longPressBlock = ^(YYControl *view, CGPoint point) {
            [weakSelf showMenuView:view imageIndex:i];
        };
    }
    _picViews = picViews;
}



//下载图片,设置图片x.y
- (void)setImageViewFrame {
    CGFloat  imageTop = 20; //imageTop图片模块的起始y值
    CGSize picSize = self.model.picSize;
    NSArray *pics = self.model.mediaKeys;
    int picsCount = (int)pics.count;
    for (int i = 0; i < 9; i++) {
        UIView *imageView = self.picViews[i];
        if (i >= picsCount) {
            [imageView.layer cancelCurrentImageRequest];
            imageView.hidden = YES;
        } else {
            CGPoint origin = {0};
            switch (picsCount) {
                case 1: {
                    origin.x = kWBCellPadding;
                    origin.y = imageTop;
                } break;
                default: {
                    origin.x = kWBCellPadding + (i % 3) * (picSize.width + kWBCellPaddingPic);
                    origin.y = imageTop + (int)(i / 3) * (picSize.height + kWBCellPaddingPic);
                } break;
            }
            imageView.frame = (CGRect){.origin = origin, .size = picSize};
            imageView.hidden = NO;
            imageView.backgroundColor = [UIColor lightGrayColor];
            [imageView.layer removeAnimationForKey:@"contents"];
            NSString *imgKey = [self.model.pic.picInfoList[i] objectForKey:@"k"];
            NSString *URL = self.model.pic.picInfoList.count == 1 ?  FILEMAXIMAGE(imgKey) : FILEMAXIMAGE(imgKey);
            @weakify(imageView); //下载图片
            [imageView.layer setImageWithURL:[NSURL URLWithString:URL]
                                 placeholder:nil
                                     options:YYWebImageOptionAvoidSetImage
                                  completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                      @strongify(imageView);
                                      if (!imageView) return;
                                      if (image && stage == YYWebImageStageFinished) {
                                          int width = image.size.width;
                                          int height = image.size.height;
                                          CGFloat scale = (height / width) / (imageView.height / imageView.width);
                                          if (scale < 0.99 || isnan(scale)) { // 宽图把左右两边裁掉
                                              imageView.contentMode = UIViewContentModeScaleAspectFill;
                                              imageView.layer.contentsRect = CGRectMake(0, 0, 1, 1);
                                          } else { // 高图只保留顶部
                                              imageView.contentMode = UIViewContentModeScaleAspectFill;
                                              imageView.layer.contentsRect = CGRectMake(0, 0.25, 1, 0.5);
                                          }
                                          ((YYControl *)imageView).image = image;
                                          if (from != YYWebImageFromMemoryCacheFast) {
                                              CATransition *transition = [CATransition animation];
                                              transition.duration = 0.15;
                                              transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                                              transition.type = kCATransitionFade;
                                              [imageView.layer addAnimation:transition forKey:@"contents"];
                                          }
                                      }
                                  }];
        }
    }
}

//根据数据 设置每张图片的图片宽高  与图片组的高度
- (void)layoutPicsWithStatus:(ICDiscoverTableViewCellViewModel *)layout {
    
    layout.picSize = CGSizeZero;
    layout.picHeight = 0;
    if (layout.mediaKeys.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = kWBCellPicHeight;
    switch (layout.mediaKeys.count) {
        case 1: {
            if(self.model.pic.width <= 300 && self.model.pic.height <= 300) { //小图,按原尺寸显示
                picSize = CGSizeMake(self.model.pic.width, self.model.pic.height);
                picHeight = self.model.pic.height;
            } else { //宽高至少有一边大于300
                CGFloat maxLen = 180; //最大高度
                if (self.model.pic.width < self.model.pic.height) { // 长图
                    
                    if (self.model.pic.height > self.model.pic.width * 3) {// 超长图单独处理
                        picSize.width = 60;
                        picSize.height = 200;
                    } else { // 正常按比例走
                        picSize.width = (float)self.model.pic.width / (float)self.model.pic.height * maxLen;
                        picSize.height = maxLen;
                    }
                } else {
                    picSize.width = maxLen;
                    picSize.height = (float)self.model.pic.height / (float)self.model.pic.width * maxLen;
                }
                picHeight = picSize.height;
            }
        } break;
        case 2: case 3: { // 2 3
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: { //4 5 6
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kWBCellPaddingPic;
        } break;
        default: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kWBCellPaddingPic * 2;
        } break;
    }
    self.model.picSize = picSize;
    self.model.picHeight = picHeight;
    self.model.picContainerHeight = self.model.picHeight + 35;
    //    self.model.picContainerHeight = self.model.picHeight + 20;
    
}
/*********************************- YYControl -**************************************/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(collectContent:)) {
        return YES;
    }
    return  [super canPerformAction:action withSender:sender];
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)showMenuView:(UIView *)showInView imageIndex:(int)index {
    self.longPressIndex = index;
    [self becomeFirstResponder];
    [[UIMenuController sharedMenuController] update];
    if (!_collectMenuItem) {
        _collectMenuItem   = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"favorites", nil) action:@selector(collectContent:)];
    }
    [[UIMenuController sharedMenuController] setMenuItems:@[_collectMenuItem]];
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)collectContent:(UIMenuItem *)collectContent {
    
    NSDictionary *picDic = [self.model.pic.picInfoList objectAtIndex:self.longPressIndex];
    NSDictionary *dic = @{@"w":[picDic objectForKey:@"w"],
                          @"h":[picDic objectForKey:@"h"]};
    
    NSString *lnk = [dic jsonString];
    // 收藏图片
    NSString *key = [[self.model.pic.picInfoList objectAtIndex:self.longPressIndex] objectForKey:@"k"];
    NSString * photoId = ![ICTools stringEmpty:self.model.photoId] ? self.model.photoId:[NSString stringWithFormat:@"eId:%@",self.model.eId];
    [self.dataController addFavoriteWithType:@"3"
                                         eId:[ICUser currentUser].eId
                                         gId:self.model.findId
                                     photoId:photoId
                                       title:self.model.eName
                                         txt:@"[图片]"
                                         key:key
                                         lnk:lnk
                                       msgId:key
                                    Callback:^(NSError *error) {
                                        if (!error) {
                                            [MBProgressHUD showSuccess:@"收藏成功"];
                                        } else {
                                            [MBProgressHUD showError:error.domain];
                                        }
                                    }];
}

@end

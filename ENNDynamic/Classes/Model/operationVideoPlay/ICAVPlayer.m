//
//  YYPhotoGroupView.m
//
//  Created by ibireme on 14/3/9.
//  Copyright (C) 2014 ibireme. All rights reserved.
//

#import "ICAVPlayer.h"
#import "ICVideoManager.h"
#import "EnnDynamicHeader.h"
#define kPadding 20
#define kHiColor [UIColor colorWithRGBHex:0x2dd6b8]


@interface ICAVPlayerGroupItem()<NSCopying>
@property (nonatomic, readonly) UIImage *thumbImage;
@property (nonatomic, readonly) BOOL thumbClippedToTop;
- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view;
@end
@implementation ICAVPlayerGroupItem

- (UIImage *)thumbImage {
    if ([_thumbView respondsToSelector:@selector(image)]) {
        if ([_thumbView isKindOfClass:[UIButton class]]) {
            return self.oglImage;
        } else {
            if (self.oglImage) {
                return self.oglImage;
            }
            return ((UIImageView *)_thumbView).image;
        }
    }
    return nil;
}

- (BOOL)thumbClippedToTop {
    if (_thumbView) {
        if (_thumbView.layer.contentsRect.size.height < 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)shouldClipToTop:(CGSize)imageSize forView:(UIView *)view {
    if (imageSize.width < 1 || imageSize.height < 1) return NO;
    if (view.width < 1 || view.height < 1) return NO;
    return imageSize.height / imageSize.width > view.width / view.height;
}

- (id)copyWithZone:(NSZone *)zone {
    ICAVPlayerGroupItem *item = [self.class new];
    return item;
}
@end



@interface ICAVPlayerGroupCell : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) YYAnimatedImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) ICAVPlayerGroupItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;
- (void)resizeSubviewSize;
@end

@implementation ICAVPlayerGroupCell

- (instancetype)init {
    self = super.init;
    if (!self) return nil;
    self.delegate = self;
    self.bouncesZoom = YES;
    self.maximumZoomScale = 3;
    self.multipleTouchEnabled = YES;
    self.alwaysBounceVertical = NO;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.frame = [UIScreen mainScreen].bounds;
    
    _imageContainerView = [UIView new];
    _imageContainerView.clipsToBounds = YES;
    [self addSubview:_imageContainerView];
    
    _imageView = [YYAnimatedImageView new];
    _imageView.clipsToBounds = YES;
    _imageView.backgroundColor = [UIColor clearColor];
    [_imageContainerView addSubview:_imageView];
    
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.size = CGSizeMake(40, 40);
    _progressLayer.cornerRadius = 20;
    _progressLayer.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(_progressLayer.bounds, 7, 7) cornerRadius:(40 / 2 - 7)];
    _progressLayer.path = path.CGPath;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;
    _progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    _progressLayer.lineWidth = 4;
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.strokeStart = 0;
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [self.layer addSublayer:_progressLayer];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _progressLayer.center = CGPointMake(self.width / 2, self.height / 2);
}

- (void)setItem:(ICAVPlayerGroupItem *)item {
    if (_item == item) {
        if (item.videoPath.length > 0) {
            _imageView.image = [self thumbnailImageForVideo:[NSURL fileURLWithPath:item.videoPath] atTime:0.1];
            [self resizeSubviewSize];
        }
        return;
    }
    _item = item;
    _itemDidLoad = NO;
    
    
    [self setZoomScale:1.0 animated:NO];
    self.maximumZoomScale = 1;
    
    [_imageView cancelCurrentImageRequest];
    [_imageView.layer removePreviousFadeAnimation];
    
    _progressLayer.hidden = NO;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _progressLayer.strokeEnd = 0;
    _progressLayer.hidden = YES;
    [CATransaction commit];
    
    if (!_item) {
        _imageView.image = nil;
        return;
    }

    UIImage *placeholderImage = [self thumbnailImageForVideo:[NSURL fileURLWithPath:_item.videoPath] atTime:0.1];
    if (placeholderImage) {
        _imageView.image = placeholderImage;
    } else {
        _imageView.image = item.thumbImage;
    }
    [self resizeSubviewSize];
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

- (void)resizeSubviewSize {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    self.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [self scrollRectToVisible:self.bounds animated:NO];
    
    if (_imageContainerView.height <= self.height) {
        self.alwaysBounceVertical = NO;
    } else {
        self.alwaysBounceVertical = YES;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _imageView.frame = _imageContainerView.bounds;
    [CATransaction commit];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView *subView = _imageContainerView;
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

@end












@interface ICAVPlayer() <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toContainerView;

@property (nonatomic, strong) UIImage *snapshotImage;
@property (nonatomic, strong) UIImage *snapshorImageHideFromView;

@property (nonatomic, strong) UIImageView *background;
@property (nonatomic, strong) UIImageView *blurBackground;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) UIPageControl *pager;
@property (nonatomic, assign) BOOL fromNavigationBarHidden;

@property (nonatomic, assign) NSInteger fromItemIndex;
@property (nonatomic, assign) BOOL isPresented;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGPoint panGestureBeginPoint;
@property (nonatomic, strong) UIImage *saveImage;

@property (nonatomic, assign) BOOL isFirstEnter;
@end

@implementation ICAVPlayer

- (instancetype)initWithGroupItems:(NSArray *)groupItems {
    self = [super init];
    if (groupItems.count == 0) return nil;
    _groupItems = groupItems.copy;
    _blurEffectBackground = YES;
    _isFirstEnter = YES;
    [self removePrePageFlag];

    NSString *model = [UIDevice currentDevice].machineModel;
    static NSMutableSet *oldDevices;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        oldDevices = [NSMutableSet new];
        [oldDevices addObject:@"iPod1,1"];
        [oldDevices addObject:@"iPod2,1"];
        [oldDevices addObject:@"iPod3,1"];
        [oldDevices addObject:@"iPod4,1"];
        [oldDevices addObject:@"iPod5,1"];
        
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,1"];
        [oldDevices addObject:@"iPhone1,2"];
        [oldDevices addObject:@"iPhone2,1"];
        [oldDevices addObject:@"iPhone3,1"];
        [oldDevices addObject:@"iPhone3,2"];
        [oldDevices addObject:@"iPhone3,3"];
        [oldDevices addObject:@"iPhone4,1"];
        
        [oldDevices addObject:@"iPad1,1"];
        [oldDevices addObject:@"iPad2,1"];
        [oldDevices addObject:@"iPad2,2"];
        [oldDevices addObject:@"iPad2,3"];
        [oldDevices addObject:@"iPad2,4"];
        [oldDevices addObject:@"iPad2,5"];
        [oldDevices addObject:@"iPad2,6"];
        [oldDevices addObject:@"iPad2,7"];
        [oldDevices addObject:@"iPad3,1"];
        [oldDevices addObject:@"iPad3,2"];
        [oldDevices addObject:@"iPad3,3"];
    });
    if ([oldDevices containsObject:model]) {
        _blurEffectBackground = NO;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    
    if (kSystemVersion >= 7) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        _panGesture = pan;
    }
    
    _cells = @[].mutableCopy;
    
    _background = UIImageView.new;
    _background.frame = self.bounds;
    _background.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _blurBackground = UIImageView.new;
    _blurBackground.frame = self.bounds;
    _blurBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _contentView = UIView.new;
    _contentView.frame = self.bounds;
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _scrollView = UIScrollView.new;
    _scrollView.frame = CGRectMake(-kPadding / 2, 0, self.width + kPadding, self.height);
    _scrollView.delegate = self;
    _scrollView.scrollsToTop = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceHorizontal = groupItems.count > 1;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scrollView.delaysContentTouches = NO;
    _scrollView.canCancelContentTouches = YES;
    
    _pager = [[UIPageControl alloc] init];
    _pager.hidesForSinglePage = YES;
    _pager.userInteractionEnabled = NO;
    _pager.width = self.width - 36;
    _pager.height = 10;
    _pager.center = CGPointMake(self.width / 2, self.height - 18);
    _pager.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self addSubview:_background];
    [self addSubview:_blurBackground];
    [self addSubview:_contentView];
    [_contentView addSubview:_scrollView];
    [_contentView addSubview:_pager];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(playerItemDidPlayToEndTimeNotification:)
                                                name:AVPlayerItemDidPlayToEndTimeNotification
                                              object:nil];

    return self;
}


- (void)presentFromVideoView:(UIView *)fromView
                 toContainer:(UIView *)toContainer
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion {
    if (!toContainer) return;
    self.userInteractionEnabled = NO;
    
    _fromView = fromView;
    _toContainerView = toContainer;
    
    NSInteger page = -1;
    for (NSUInteger i = 0; i < self.groupItems.count; i++) {
        if (fromView == ((ICAVPlayerGroupItem *)self.groupItems[i]).thumbView) {
            page = (int)i;
            break;
        }
    }
    if (page == -1) page = 0;
    _fromItemIndex = page;
    
    _snapshotImage = [_toContainerView snapshotImageAfterScreenUpdates:NO];
    BOOL fromViewHidden = fromView.hidden;
    fromView.hidden = YES;
    _snapshorImageHideFromView = [_toContainerView snapshotImage];
    fromView.hidden = fromViewHidden;
    
    _background.image = _snapshorImageHideFromView;
    if (_blurEffectBackground) {
        _blurBackground.image = [_snapshorImageHideFromView imageByBlurDark]; //Same to UIBlurEffectStyleDark
    } else {
        _blurBackground.image = [UIImage imageWithColor:[UIColor blackColor]];
    }
    
    self.size = _toContainerView.size;
    self.blurBackground.alpha = 0;
    self.pager.alpha = 0;
    self.pager.numberOfPages = self.groupItems.count;
    self.pager.currentPage = page;
    [_toContainerView addSubview:self];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width * self.groupItems.count, _scrollView.height);
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.width * _pager.currentPage, 0, _scrollView.width, _scrollView.height) animated:NO];
    [self scrollViewDidScroll:_scrollView];
    
    [UIView setAnimationsEnabled:YES];
    _fromNavigationBarHidden = [UIApplication sharedApplication].statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    
    
    ICAVPlayerGroupCell *cell = [self cellForPage:self.currentPage];
    ICAVPlayerGroupItem *item = _groupItems[self.currentPage];
    
    if (!item.thumbClippedToTop) {
        NSString *imageKey = [[YYWebImageManager sharedManager] cacheKeyForURL:item.largeImageURL];
        if ([[YYWebImageManager sharedManager].cache getImageForKey:imageKey withType:YYImageCacheTypeMemory]) {
            cell.item = item;
        }
    }
    if (!cell.item) {
        cell.imageView.image = item.thumbImage;
        [cell resizeSubviewSize];
    }
    
    if (item.thumbClippedToTop) {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell];
        CGRect originFrame = cell.imageContainerView.frame;
        CGFloat scale = fromFrame.size.width / cell.imageContainerView.width;
        
        cell.imageContainerView.centerX = CGRectGetMidX(fromFrame);
        cell.imageContainerView.height = fromFrame.size.height / scale;
        cell.imageContainerView.layer.transformScale = scale;
        cell.imageContainerView.centerY = CGRectGetMidY(fromFrame);
        
        float oneTime = animated ? 0.25 : 0;
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _blurBackground.alpha = 1;
        }completion:NULL];
        
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageContainerView.layer.transformScale = 1;
            cell.imageContainerView.frame = originFrame;
            _pager.alpha = 1;
        }completion:^(BOOL finished) {
            _isPresented = YES;
            [self scrollViewDidScroll:_scrollView];
            self.userInteractionEnabled = YES;
            [self hidePager];
            if (completion) completion();
        }];
        
    } else {
        CGRect fromFrame = [_fromView convertRect:_fromView.bounds toView:cell.imageContainerView];
        
        cell.imageContainerView.clipsToBounds = NO;
        cell.imageView.frame = fromFrame;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        float oneTime = animated ? 0.3 : 0;
        [UIView animateWithDuration:oneTime*2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            _blurBackground.alpha = 1;
        }completion:NULL];
        
        [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.imageView.frame = cell.imageContainerView.bounds;
            cell.imageView.layer.transformScale = 1.01;
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:oneTime delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.imageView.layer.transformScale = 1.0;
                _pager.alpha = 1;
            }completion:^(BOOL finished) {
                cell.imageContainerView.clipsToBounds = YES;
                _isPresented = YES;
                [self scrollViewDidScroll:_scrollView];
                self.userInteractionEnabled = YES;
                [self hidePager];
                if (completion) completion();
            }];
        }];
    }
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [UIView setAnimationsEnabled:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:animated ? UIStatusBarAnimationFade : UIStatusBarAnimationNone];
    
    if ([self.delegate respondsToSelector:@selector(closePlayerViewAction)]) {
        [self.delegate closePlayerViewAction];
    }
    self.playerLayer.hidden = YES;

    NSInteger currentPage = self.currentPage;
    ICAVPlayerGroupCell *cell = [self cellForPage:currentPage];
    ICAVPlayerGroupItem *item = _groupItems[currentPage];
    
    UIView *fromView = nil;
    if (_fromItemIndex == currentPage) {
        fromView = _fromView;
    } else {
        fromView = item.thumbView;
    }
    
    [self cancelAllImageLoad];
    _isPresented = NO;
    BOOL isFromImageClipped = fromView.layer.contentsRect.size.height < 1;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (isFromImageClipped) {
        CGRect frame = cell.imageContainerView.frame;
        cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0);
        cell.imageContainerView.frame = frame;
    }
    cell.progressLayer.hidden = YES;
    [CATransaction commit];
    
    
    
    
    if (fromView == nil) {
        self.background.image = _snapshotImage;
        [UIView animateWithDuration:animated ? 0.25 : 0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
            self.scrollView.layer.transformScale = 0.95;
            self.scrollView.alpha = 0;
            self.pager.alpha = 0;
            self.blurBackground.alpha = 0;
        }completion:^(BOOL finished) {
            self.scrollView.layer.transformScale = 1;
            [self releasePlayer];
            [self removeFromSuperview];
            [self cancelAllImageLoad];
            if (completion) completion();
        }];
        return;
    }
    
    if (_fromItemIndex != currentPage) {
        _background.image = _snapshotImage;
        [_background.layer addFadeAnimationWithDuration:0.25 curve:UIViewAnimationCurveEaseOut];
    } else {
        _background.image = _snapshorImageHideFromView;
    }
    
    
    if (isFromImageClipped) {
        [cell scrollToTopAnimated:NO];
    }
    
    [UIView animateWithDuration:animated ? 0.2 : 0 delay:0.1 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        _pager.alpha = 0.0;
        _blurBackground.alpha = 0.0;
        if (isFromImageClipped) {
            
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell];
            CGFloat scale = fromFrame.size.width / cell.imageContainerView.width * cell.zoomScale;
            CGFloat height = fromFrame.size.height / fromFrame.size.width * cell.imageContainerView.width;
            if (isnan(height)) height = cell.imageContainerView.height;
            
            cell.imageContainerView.height = height;
            cell.imageContainerView.center = CGPointMake(CGRectGetMidX(fromFrame), CGRectGetMinY(fromFrame));
            cell.imageContainerView.layer.transformScale = scale;
            
        } else {
            CGRect fromFrame = [fromView convertRect:fromView.bounds toView:cell.imageContainerView];
            cell.imageContainerView.clipsToBounds = NO;
            cell.imageView.contentMode = fromView.contentMode;
            cell.imageView.frame = fromFrame;
        }
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:animated ? 0.15 : 0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            cell.imageContainerView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self releasePlayer];
            [self removeFromSuperview];
            if (completion) completion();
        }];
    }];
    
    
}

- (void)dismiss {
    [self dismissAnimated:YES completion:^{
        [self removeAVPlayerFlag];
    }];
}


- (void)cancelAllImageLoad {
    [_cells enumerateObjectsUsingBlock:^(ICAVPlayerGroupCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.imageView cancelCurrentImageRequest];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateCellsForReuse];

    CGFloat floatPage = _scrollView.contentOffset.x / _scrollView.width;
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    
    for (NSInteger i = page - 1; i <= page + 1; i++) { // preload left and right cell
        if (i >= 0 && i < self.groupItems.count) {
            ICAVPlayerGroupCell *cell = [self cellForPage:i];
            if (!cell) {
                ICAVPlayerGroupCell *cell = [self dequeueReusableCell];
                cell.page = i;
                cell.left = (self.width + kPadding) * i + kPadding / 2;
                
                if (_isPresented) {
                    cell.item = self.groupItems[i];
                }
                [self.scrollView addSubview:cell];
            } else {
                if (_isPresented && !cell.item) {
                    cell.item = self.groupItems[i];
                }
            }
        }
    }
    
    NSInteger intPage = floatPage + 0.5;
    intPage = intPage < 0 ? 0 : intPage >= _groupItems.count ? (int)_groupItems.count - 1 : intPage;
    _pager.currentPage = intPage;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        _pager.alpha = 1;
    }completion:^(BOOL finish) {
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _isFirstEnter = NO;

    if (!decelerate) {
        [self hidePager];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self hidePager];
}


- (void)hidePager {
    // video ready play
    [self videoReadyPlay];

    [UIView animateWithDuration:0.3 delay:0.8 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        _pager.alpha = 0;
    }completion:^(BOOL finish) {
    }];
}

/// enqueue invisible cells for reuse
- (void)updateCellsForReuse {
    for (ICAVPlayerGroupCell *cell in _cells) {
        if (cell.superview) {
            if (cell.left > _scrollView.contentOffset.x + _scrollView.width * 2||
                cell.right < _scrollView.contentOffset.x - _scrollView.width) {
                [cell removeFromSuperview];
                cell.page = -1;
                cell.item = nil;
            }
        }
    }
}

/// dequeue a reusable cell
- (ICAVPlayerGroupCell *)dequeueReusableCell {
    ICAVPlayerGroupCell *cell = nil;
    for (cell in _cells) {
        if (!cell.superview) {
            return cell;
        }
    }
    
    cell = [ICAVPlayerGroupCell new];
    cell.frame = self.bounds;
    cell.imageContainerView.frame = self.bounds;
    cell.imageView.frame = cell.bounds;
    cell.page = -1;
    cell.item = nil;
    [_cells addObject:cell];
    return cell;
}

/// get the cell for specified page, nil if the cell is invisible
- (ICAVPlayerGroupCell *)cellForPage:(NSInteger)page {
    for (ICAVPlayerGroupCell *cell in _cells) {
        if (cell.page == page) {
            return cell;
        }
    }
    return nil;
}

- (NSInteger)currentPage {
    NSInteger page = _scrollView.contentOffset.x / _scrollView.width + 0.5;
    if (page >= _groupItems.count) page = (NSInteger)_groupItems.count - 1;
    if (page < 0) page = 0;
    [self savePrePageFlag: _isFirstEnter ? -1 : page];
    return page;
}

- (void)pan:(UIPanGestureRecognizer *)g {
    switch (g.state) {
        case UIGestureRecognizerStateBegan: {
            if (_isPresented) {
                _panGestureBeginPoint = [g locationInView:self];
            } else {
                _panGestureBeginPoint = CGPointZero;
            }
        } break;
        case UIGestureRecognizerStateChanged: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            _scrollView.top = deltaY;
            
            CGFloat alphaDelta = 160;
            CGFloat alpha = (alphaDelta - fabs(deltaY) + 50) / alphaDelta;
            alpha = YY_CLAMP(alpha, 0, 1);
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
                _blurBackground.alpha = alpha;
                _pager.alpha = alpha;
            } completion:nil];
            
        } break;
        case UIGestureRecognizerStateEnded: {
            if (_panGestureBeginPoint.x == 0 && _panGestureBeginPoint.y == 0) return;
            CGPoint v = [g velocityInView:self];
            CGPoint p = [g locationInView:self];
            CGFloat deltaY = p.y - _panGestureBeginPoint.y;
            
            if (fabs(v.y) > 1000 || fabs(deltaY) > 120) {
                [self cancelAllImageLoad];
                _isPresented = NO;
                [[UIApplication sharedApplication] setStatusBarHidden:_fromNavigationBarHidden withAnimation:UIStatusBarAnimationFade];
                
                BOOL moveToTop = (v.y < - 50 || (v.y < 50 && deltaY < 0));
                CGFloat vy = fabs(v.y);
                if (vy < 1) vy = 1;
                CGFloat duration = (moveToTop ? _scrollView.bottom : self.height - _scrollView.top) / vy;
                duration *= 0.8;
                duration = YY_CLAMP(duration, 0.05, 0.3);
                
                [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _blurBackground.alpha = 0;
                    _pager.alpha = 0;
                    if (moveToTop) {
                        _scrollView.bottom = 0;
                    } else {
                        _scrollView.top = self.height;
                    }
                } completion:^(BOOL finished) {
                    [self releasePlayer];
                    [self removeFromSuperview];
                    [self removeAVPlayerFlag];
                }];
                
                _background.image = _snapshotImage;
                [_background.layer addFadeAnimationWithDuration:0.3 curve:UIViewAnimationCurveEaseInOut];
                
            } else {
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:v.y / 1000 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                    _scrollView.top = 0;
                    _blurBackground.alpha = 1;
                    _pager.alpha = 1;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
        } break;
        case UIGestureRecognizerStateCancelled : {
            _scrollView.top = 0;
            _blurBackground.alpha = 1;
        }
        default:break;
    }
}

- (void)videoReadyPlay {
    NSInteger prePage = [self getPrePageFlag];
    if (prePage == self.currentPage) {
        return;
    }
    
    [self releasePlayer];

    ICAVPlayerGroupCell *cell = [self cellForPage:self.currentPage];
    ICAVPlayerGroupItem *item = _groupItems[self.currentPage];
    
    //download video
    WEAKSELF
    NSString *path = [[ICVideoManager shareManager] videoPathWithFileName:item.fileKey fileDir:kDiscvoerVideoPath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data && ![ICTools stringEmpty:item.fileKey]) { // 本地没数据 进行网络请求
        [[ICNetworkManager sharedInstance] downloadMedia:item.fileKey fileDir:kDiscvoerVideoPath progress:^(NSProgress *pro) {
            CGFloat progress = pro.fractionCompleted;
            
            progress = progress < 0.01 ? 0.01 : progress > 1 ? 1 : progress;
            if (isnan(progress)) progress = 0;
            
            cell.progressLayer.hidden = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.progressLayer.strokeEnd = progress;
            });
        } success:^(id object) {
            [weakSelf playVideoWithCell:cell item:item];
        } failure:^(NSError *error) {
            cell.progressLayer.hidden = YES;
        }];
    } else {
        [self playVideoWithCell:cell item:item];
    }
}

- (void)playVideoWithCell:(ICAVPlayerGroupCell *)cell item:(ICAVPlayerGroupItem *)item {
    cell.item = item;
    cell.progressLayer.hidden = YES;
    [cell.imageView.layer removeAllSublayers];
    
    // player
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:item.videoPath]];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    // AVPlayerLayer
    self.playerLayer.frame = cell.imageView.bounds;
    [cell.imageView.layer addSublayer:self.playerLayer];
    [self.player play];
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        _player.usesExternalPlaybackWhileExternalScreenIsActive = YES;
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResize;
    }
    return _playerLayer;
}

- (void)savePrePageFlag:(NSInteger)page {
    NSInteger prePage = [[NSUserDefaults standardUserDefaults] integerForKey:@"prePage"];
    if (prePage != page) {
        [[NSUserDefaults standardUserDefaults] setInteger:page forKey:@"prePage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSInteger)getPrePageFlag {
    NSInteger prePage = [[NSUserDefaults standardUserDefaults] integerForKey:@"prePage"];
    return prePage;
}

- (void)removePrePageFlag {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"prePage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAVPlayerFlag {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avPlayerFlag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)playerItemDidPlayToEndTimeNotification:(NSNotification *)sender {
    [self.player seekToTime:kCMTimeZero]; // seek to zero
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)releasePlayer {
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self.player pause];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
    self.playerItem = nil;
    self.playerLayer = nil;
}


@end

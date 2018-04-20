//
//  ICShortVideoController.m
//  ICome
//
//  Created by zhangrongwu on 16/5/4.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICShortVideoController.h"
#import "ICShortVideoProgressView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ICVideoManager.h"

#define kMaxVideoLength 10
#define kProgressTimerTimeInterval 0.015
#define kHomeTableViewAnimationDuration 0.5

#define kCameraHeight 480.0 / 640.0 * App_Frame_Width
typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface ICShortVideoController () <UIGestureRecognizerDelegate>


@property (strong, nonatomic) UIView *viewContainer;
@property (strong, nonatomic) UIButton *takeButton;//拍照按钮

@property (nonatomic, strong) ICShortVideoProgressView *progressView;

@property (nonatomic, assign) CGFloat kCameraStart;

@property (nonatomic, strong) UILabel *cancelAlertLabel;

@property (nonatomic, strong) NSTimer *progressTimer;

@property (nonatomic, assign) CGFloat videoLength;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, assign) BOOL shouldCancel;

@property (nonatomic, strong) NSString *videoName;

@end

@implementation ICShortVideoController
- (instancetype)init {
    if (self = [super init]) {
        if (App_Frame_Width == 375) {
            self.kCameraStart = 170;
        } else if (App_Frame_Width == 320) {
            self.kCameraStart = 150;
        } else if (App_Frame_Width == 414){
            self.kCameraStart = 190;
        }
        [self setNav];
        [self setUI];
        [self initCaptureSession];
        [self show];
     
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initCaptureSession {
    [[ICVideoManager shareManager] setVideoPreviewLayer:self.viewContainer];
}

- (void)setNav {
    self.title = NSLocalizedString(@"videoClips", nil);
    //[self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"App_back_blue"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"App_back_blue" itemType:UIBarButtonItemTypeLeft target:self action:@selector(backClick)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBarTintColor:ICRGB(0x0d0d0d)];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBarTintColor:NE_BACKGROUND_COLOR];
}

- (void)setUI {
    self.view.backgroundColor = ICRGB(0x1a1a1a);
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    self.pan.delegate = self;
    [self.view addGestureRecognizer:self.pan];
    
    [self.progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewContainer.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(App_Frame_Width);
        make.height.mas_equalTo(1);
    }];
    
    [self.takeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.and.height.mas_equalTo(self.kCameraStart);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
    }];
    
    [self.cancelAlertLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewContainer.mas_bottom).offset(-40);
        make.centerX.equalTo(self.viewContainer.mas_centerX);
        make.height.mas_equalTo(20);
    }];
}

- (void)backClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)panView:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:pan.view];
    CGRect touchRect = CGRectMake(point.x, point.y, 1, 1);
    BOOL isIn = CGRectIntersectsRect(self.takeButton.frame, touchRect);
    
    self.cancelAlertLabel.hidden = isIn;
    self.shouldCancel = !isIn;
    
    UIColor *tintColor = [UIColor greenColor];
    if (!isIn) {
        tintColor = [UIColor redColor];
    }
    
    [self.takeButton setTitleColor:tintColor forState:UIControlStateNormal];
    self.progressView.progressLine.backgroundColor = tintColor;
    
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed) {
        if (!isIn) {
            [self cancelRecordingVideo];
        } else {
            [self endRecordingVideo];
        }
    }
}
- (void)cancelRecordingVideo {
    [self removeTimer];
    [self recordVideoCanceled];
    
    self.cancelAlertLabel.hidden = YES;
    UIColor *tintColor = [UIColor greenColor];
    [self.takeButton setTitleColor:tintColor forState:UIControlStateNormal];
    self.progressView.progressLine.backgroundColor = tintColor;
}
- (void)setupTimer {
    self.progressView.hidden = NO;
    self.videoLength = 0;
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:kProgressTimerTimeInterval
                                                          target:self
                                                        selector:@selector(updateProgress)
                                                        userInfo:nil
                                                         repeats:YES];
}

- (void)removeTimer {
    self.progressView.progress = 0;
    self.progressView.hidden = YES;
    
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgress {
    if (self.videoLength >= kMaxVideoLength) {
        [self removeTimer];
        [self endRecordingVideo];
        return;
    }
    self.videoLength += kProgressTimerTimeInterval;
    CGFloat progress = self.videoLength / kMaxVideoLength;
    self.progressView.progress = progress;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[ICVideoManager shareManager] exit];
}

#pragma mark - UI方法
- (void)show {
    self.pan.enabled = YES;
    self.view.frame = [UIScreen mainScreen].bounds;
    self.viewContainer.hidden = NO;
    self.takeButton.hidden = self.viewContainer.hidden;
    [self.view layoutSubviews];
}

#pragma mark 视频录制
- (void)startRecordingVideo {
    [self setupTimer];
    self.videoName = [NSString currentName];
    [[ICVideoManager shareManager] startRecordingVideoWithFileName:self.videoName];
}

- (void)endRecordingVideo {
    if (self.videoLength < 1.0) {
        [MBProgressHUD showError:@"手指不要放开"];
        [self removeTimer];
        [self recordVideoCanceled];
    } else {
        [self removeTimer];
        WEAKSELF
        [[ICVideoManager shareManager] stopRecordingVideo:^(NSString *path) {
            if (weakSelf.finishOperratonBlock) {
                weakSelf.finishOperratonBlock(path);
                [weakSelf backClick];
            }
        }];
    }
}

- (void)recordVideoCanceled {
    [[ICVideoManager shareManager] stopRecordingVideo:^(NSString *path) {
        // 删除已经录制的文件
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[ICVideoManager shareManager] cancelRecordingVideoWithFileName:_videoName];
        });
    }];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(UIView *)viewContainer {
    if (!_viewContainer) {
        CGRect rect = CGRectMake(0, 0, App_Frame_Width, kCameraHeight);
        _viewContainer = [[UIView alloc] initWithFrame:rect];
        [self.view addSubview:self.viewContainer];
    }
    return _viewContainer;
}

-(ICShortVideoProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ICShortVideoProgressView alloc] initWithFrame:CGRectMake(0, kCameraHeight, App_Frame_Width, 2)];
        _progressView.hidden = YES;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

-(UIButton *)takeButton {
    if (!_takeButton) {
        _takeButton = [UIButton new];
        _takeButton.hidden = YES;
        [_takeButton setTitle:@"按住拍" forState:UIControlStateNormal];
        [_takeButton addTarget:self action:@selector(startRecordingVideo) forControlEvents:UIControlEventTouchDown];
        [_takeButton addTarget:self action:@selector(endRecordingVideo) forControlEvents:UIControlEventTouchUpInside];
        [_takeButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.view addSubview:_takeButton];
        _takeButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _takeButton.layer.borderWidth = 1;
        _takeButton.layer.cornerRadius = self.kCameraStart / 2;
    }
    return _takeButton;
}

-(UILabel *)cancelAlertLabel {
    if (!_cancelAlertLabel) {
        _cancelAlertLabel = [UILabel new];
        _cancelAlertLabel.text = @" 松手取消 ";
        _cancelAlertLabel.textColor = [UIColor whiteColor];
        _cancelAlertLabel.backgroundColor = [UIColor redColor];
        _cancelAlertLabel.hidden = YES;
        [self.view addSubview:_cancelAlertLabel];
    }
    return _cancelAlertLabel;
}


@end

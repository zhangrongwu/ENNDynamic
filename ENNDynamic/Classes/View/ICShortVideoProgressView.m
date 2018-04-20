//
//  ICShortVideoProgressView.m
//  ICome
//
//  Created by zhangrongwu on 16/5/4.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICShortVideoProgressView.h"
#import "EnnDynamicHeader.h"
@implementation ICShortVideoProgressView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _progressLine = [[UIView alloc] init];
        _progressLine.backgroundColor = [UIColor greenColor];
        [self addSubview:_progressLine];
        _progressLine.frame = self.bounds;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    if (progress >= 0 && progress <= 1.0) {
        [self updateProgressLineWithProgress:progress];
    }
}

- (void)updateProgressLineWithProgress:(CGFloat)Progress {
    if (_progressLine.width > self.width) {
        _progressLine.frame = self.bounds;
        _progressLine.transform = CGAffineTransformIdentity;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat x = MIN((1 - Progress), 1);
        _progressLine.transform = CGAffineTransformMakeScale(x, 1);
        [_progressLine setNeedsDisplay];
    });
}
@end

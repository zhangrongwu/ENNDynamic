//
//  UIImage+Extension.h
//  ICome
//
//  Created by ENN on 16/3/10.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;

// add image to another image
+ (UIImage *)addImage:(UIImage *)firstImg
              toImage:(UIImage *)secondImg;

+ (UIImage *)addImage2:(UIImage *)firstImg
              toImage:(UIImage *)secondImg;

+ (UIImage *)makeArrowImageWithSize:(CGSize)imageSize
                              image:(UIImage *)image
                           isSender:(BOOL)isSender;

// compress image
+ (UIImage *)simpleImage:(UIImage *)originImg;

+ (UIImage *)videoFramerateWithPath:(NSString *)videoPath;
/** 头像图片裁剪*/
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
- (UIImage *)fixOrientation;

//+(UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/// 将图片压缩到指定宽度
- (UIImage *)jkr_compressWithWidth:(CGFloat)width;
/// 将图片在子线程中压缩，block在主线层回调
- (void)jkr_compressToDataLength:(NSInteger)length withBlock:(void(^)(NSData *data))block;
/// 尽量将图片压缩到指定大小
- (void)jkr_tryCompressToDataLength:(NSInteger)length withBlock:(void(^)(NSData *data))block;
/// 快速将图片压缩到指定大小
- (void)jkr_fastCompressToDataLength:(NSInteger)length withBlock:(void(^)(NSData *data))block;

@end

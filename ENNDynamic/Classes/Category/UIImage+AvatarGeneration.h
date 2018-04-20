//
//  UIImage+AvatarGeneration.h
//  ICome
//
//  Created by Administrator on 2017/5/15.
//  Copyright © 2017年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AvatarGeneration)




-(UIImage *)getImageFromImageRect:(CGRect)rect;

/**
 生成单人头像

 @param iamgeView iamgeView description
 @param urlStr urlStr description
 @param eId eId description
 @param name name description
 */
+(void)addAvatariamgeView:(UIImageView *)iamgeView withUrlStr:(NSString *)urlStr witheId:(NSString *)eId withName:(NSString *)name;

/**
 生成单人头像

 @param number 背景色取值
 @param name 绘制的字
 @return 返回UIimage
 */
+ (UIImage *)SingleAvatarBuildereId:(NSUInteger)eId withName:(NSString *)name withSize:(CGSize)size withPiont:(CGPoint)point;


+ (UIImage *)SingleAvatarBuildereId:(NSUInteger)eId withPhotoId:(NSString *)photoId withName:(NSString *)name withSize:(CGSize)size withPiont:(CGPoint)point;






/**
  群头像生成

 @param urlStr 群头像URL
 @param gId 群ID
 @param size 生成头像大小
 @return 返回Image
 */
+(void)GroupHeadView:(UIImageView *)imageView  withUrlStr:(NSString *)urlStr withgId:(NSString *)gId withSize:(CGSize)size;

+(UIImage *)GroupHeadgId:(NSString *)gId withSize:(CGSize)size;

+(UIImage *)ComposeaddUser:(ICUser *)user toImage:(ICUser *)user2 withSize:(CGSize)size;



+(UIImage *)ComposeaddUserArray:(NSArray *)userArray withSize:(CGSize)size;

/**
 群头像生成

 @param array 数组成员ICUser
 @return 返回UIimage
 */
+ (void)GroupHeadView:(UIImageView *)imageView GroupHeadGenerator:(NSArray *)array withSize:(CGSize)size;




/**
生成二维码

 @param string URL
 @param Imagesize 图片大小
 @param waterImagesize logo图大小
 @return 返回UIImage
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;





@end

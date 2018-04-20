//
//  ICMediaManager.h
//  ICome
//
//  Created by ENN on 16/3/12.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kMyPic @"Chat/MyPic"
#define kVideoPic @"Chat/VideoPic"
#define kDeliver @"Deliver"

@interface ICMediaManager : NSObject

+ (instancetype)sharedManager;

/**
 *  get image from local path
 *
 *  @param localPath 路径
 *
 *  @return 图片
 */
- (UIImage *)imageWithLocalPath:(NSString *)localPath;


/**
 *  保存图片到沙盒
 *
 *  @param image 图片
 *
 *  @return 图片路径
 */
- (NSString *)saveImage:(UIImage *)image;

- (void)clearCaches;

// 发送图片的地址
- (NSString *)getLocationImagePath:(NSString *)imgName;


// 小图路径
- (NSString *)smallImgPath:(NSString *)fileKey;


// get image with imgName
- (NSString *)imagePathWithName:(NSString *)imageName;


// 送达号
- (NSString *)deliverFilePath:(NSString *)name
                         type:(NSString *)type;

- (NSString *)videoImagePath:(NSString *)fileName;





@end

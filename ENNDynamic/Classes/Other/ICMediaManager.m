//
//  ICMediaManager.m
//  ICome
//
//  Created by ENN on 16/3/12.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICMediaManager.h"
#import "UIImage+Extension.h"
#import "NSData+Image.h"
#import "ICFileTool.h"

static UIImage *_failedImage;
@interface ICMediaManager ()

@property (nonatomic, strong) NSCache *videoImageCache;
@property (nonatomic, strong) NSCache *photoCache;

@end

@implementation ICMediaManager

+ (instancetype)sharedManager
{
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_instance selector:@selector(clearCaches) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        _failedImage  = [UIImage imageWithColor:[UIColor lightGrayColor]];
    });
    return _instance;
}


- (void)clearCaches
{
    [self.videoImageCache removeAllObjects];
    [self.photoCache removeAllObjects];
}

// 使用文件名为key
- (UIImage *)imageWithLocalPath:(NSString *)localPath
{
    if ([self.photoCache objectForKey:localPath.lastPathComponent]) {
        return [self.photoCache objectForKey:localPath.lastPathComponent];
    } else if (![localPath hasSuffix:@".png"]) {
        return nil;
    }
    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
    if (image) {
        [self.photoCache setObject:image forKey:localPath.lastPathComponent];
    } else {
        image = _failedImage;
        [self.photoCache setObject:image forKey:localPath.lastPathComponent];
    }
    return image;
}



- (void)fileManagerWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir) {
            return ;
        }
    }
}


// 路径cache/MyPic
- (NSString *)createFolderPahtWithMainFolder:(NSString *)mainFolder
                                 childFolder:(NSString *)childFolder
{
    NSString *path = [mainFolder stringByAppendingPathComponent:childFolder];
    [self fileManagerWithPath:path];
    return path;
}


/**
 *  保存图片到沙盒
 *
 *  @param image 图片
 *
 *  @return 图片路径
 */
- (NSString *)saveImage:(UIImage *)image
{
    
    NSData *imageData = [NSData imageData:image];
    
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // 图片名称
    NSString *fileName = [NSString stringWithFormat:@"IMG_%U%u%@", arc4random() % 1000, arc4random() % 100 ,@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:kMyPic];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:NO];
    return filePath;
}

// 发送图片的地址
- (NSString *)getLocationImagePath:(NSString *)imgName
{
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [NSString stringWithFormat:@"%@",imgName];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:chachePath childFolder:kMyPic];
    NSString *filePath = [mainFilePath stringByAppendingPathComponent:fileName];
    return filePath;

}


// get videoImage from sandbox
- (UIImage *)videoImageWithFileName:(NSString *)fileName
{
    return [UIImage imageWithContentsOfFile:[self videoImagePath:fileName]];
}

- (NSString *)videoImagePath:(NSString *)fileName
{
    NSString *path = [[ICFileTool cacheDirectory] stringByAppendingPathComponent:kVideoPic];
    [self fileManagerWithPath:path];
    NSString *fullPath = [path stringByAppendingPathComponent:fileName];
    return fullPath;
}


// 保存接收到图片   fileKey-small.png
- (NSString *)receiveImagePathWithFileKey:(NSString *)fileKey
                                     type:(NSString *)type
{
    // 目前是png，以后说不定要改
    NSString *fileName = [NSString stringWithFormat:@"%@-%@%@",fileKey,type,@".png"];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:[ICFileTool cacheDirectory] childFolder:kMyPic];
    return [mainFilePath stringByAppendingPathComponent:fileName];
}

// get image with imgName
- (NSString *)imagePathWithName:(NSString *)imageName
{
    return [[[ICFileTool cacheDirectory] stringByAppendingPathComponent:kMyPic] stringByAppendingPathComponent:imageName];
}

// small image path
- (NSString *)smallImgPath:(NSString *)fileKey
{
    return [[ICMediaManager sharedManager] receiveImagePathWithFileKey:fileKey type:@"small"];
}

- (NSString *)deliverFilePath:(NSString *)name
                         type:(NSString *)type
{
    NSString *fileName = [NSString stringWithFormat:@"%@.%@",name,type];
    NSString *mainFilePath = [self createFolderPahtWithMainFolder:[ICFileTool cacheDirectory] childFolder:kDeliver];
    return [mainFilePath stringByAppendingPathComponent:fileName];
}


#pragma mark - Getter and Setter

- (NSCache *)videoImageCache
{
    if (nil == _videoImageCache) {
        _videoImageCache = [[NSCache alloc] init];
    }
    return _videoImageCache;
}


- (NSCache *)photoCache
{
    if (nil == _photoCache) {
        _photoCache = [[NSCache alloc] init];
    }
    return _photoCache;
}









@end

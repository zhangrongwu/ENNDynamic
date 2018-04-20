//
//  UIImage+AvatarGeneration.m
//  ICome
//
//  Created by Administrator on 2017/5/15.
//  Copyright © 2017年 iCom. All rights reserved.
//  头像生成

#import "UIImage+AvatarGeneration.h"
#import "NSString+Chinese.h"
#import "NSString+Extension.h"
#import "ICTools.h"


@implementation UIImage (AvatarGeneration)

static CGFloat Wdth = 1.0;

//截取图片区域
-(UIImage *)getImageFromImageRect:(CGRect)rect
{
    CGRect myImageRect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    UIImage* bigImage= self;
    
    CGImageRef imageRef = bigImage.CGImage;
    
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    
    CGSize size;
    
    size.width = self.size.width/2;
    
    size.height = self.size.height;
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();  
    
    
    return smallImage;
}

+(void)addAvatariamgeView:(UIImageView *)iamgeView withUrlStr:(NSString *)urlStr witheId:(NSString *)eId withName:(NSString *)name 
{
     iamgeView.contentMode = UIViewContentModeScaleAspectFit;
    NSRange range = [urlStr rangeOfString:@"="]; //现获取要截取的字符串位置
    NSString * result = [urlStr substringFromIndex:range.location+1]; //截取字符串
    if(result.length < 8){
        if([ICTools stringEmpty:eId] || [ICTools stringEmpty:name])
        {//无eId或无名字
            iamgeView.image =[UIImage imageNamed:@"App_personal_headimg"];
        }else
        {
            iamgeView.image =[UIImage imageNamed:@"App_personal_headimg"];
//            iamgeView.image = [UIImage SingleAvatarBuildereId:[eId characterAtIndex:eId.length-1]  withName:name withSize:CGSizeMake(160, 160) withPiont:CGPointMake(0, 0)];
        }
        
    }else{
        [iamgeView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage: [UIImage SingleAvatarBuildereId:[eId characterAtIndex:eId.length-1]  withName:name withSize:CGSizeMake(160, 160) withPiont:CGPointMake(0, 0)] options:SDWebImageRetryFailed];
    }
}

//
+ (UIImage *)SingleAvatarBuildereId:(NSUInteger)eId withName:(NSString *)name withSize:(CGSize)size withPiont:(CGPoint)point
{
    return [UIImage imageNamed:@"App_personal_headimg"];
//    NSInteger colorshu = eId%7;
//    UIColor *color = ICHeaderBG_0;
//    switch (colorshu) {
//        case 0:color = ICHeaderBG_0; break;
//        case 1:color = ICHeaderBG_1; break;
//        case 2:color = ICHeaderBG_2; break;
//        case 3:color = ICHeaderBG_3; break;
//        case 4:color = ICHeaderBG_4; break;
//        case 5:color = ICHeaderBG_5; break;
//        case 6:color = ICHeaderBG_6; break;
//        default:
//            break;
//    }
//    CGRect rect = CGRectMake(0, 0, size.width, size.height);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImage *headerimg = [self imageToAddText:img withText:[name obtainCharacter] withRect:CGRectMake((size.width)/4,(size.height)*5/16, size.width/2,(size.height)/2) withPiont:point];
//    return headerimg;
}

//把文字绘制到图片上
+ (UIImage *)imageToAddText:(UIImage *)img withText:(NSString *)text withRect:(CGRect)rect withPiont:(CGPoint)point;
{
    //1.获取上下文
    UIGraphicsBeginImageContext(img.size);
    //2.绘制图片
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //3.绘制文字
//    CGRect rect = CGRectMake((img.size.width)/4,(img.size.height)/4, img.size.width/2,(img.size.height)/2);
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    //文字的属性
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:img.size.width*3/7],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor whiteColor]};
     CGRect rect1 = [text stringWidthRectWithSize:rect.size fontOfSize:img.size.width*3/7];
    
    if(point.x == 0 && point.y == 0){
        rect = CGRectMake((img.size.width-rect1.size.width)/2, (img.size.height-rect1.size.height)/2, rect1.size.width, rect1.size.height);
    }else{
        rect = CGRectMake((img.size.width-rect1.size.width)/2*(20+point.x)/20, (img.size.height-rect1.size.height)/2*(20+point.y)/20, rect1.size.width, rect1.size.height);
    }
    //将文字绘制上去
    [text drawInRect:rect withAttributes:dic];
    //4.获取绘制到得图片
    UIImage *watermarkImg = UIGraphicsGetImageFromCurrentImageContext();
    //5.结束图片的绘制
    UIGraphicsEndImageContext();
    
    return watermarkImg;
}


//生成群头像
+(void)GroupHeadView:(UIImageView *)imageView  withUrlStr:(NSString *)urlStr withgId:(NSString *)gId withSize:(CGSize)size;
{
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    // 同步控制图片查询
    if ([ICSyncManager sharedInstance].isSynchronizing) {
        imageView.image = [UIImage imageNamed:@"App_personal_headimg"];
        return;
    }
    __block NSMutableArray * dataarray = [[NSMutableArray alloc]init];
    [ICMessageDatabase getUsersWithGroupId:gId limit:4 finish:^(NSArray *array, NSError *error) {
        if(array.count == 0){
        }else{
            dataarray = (NSMutableArray *)array;
        }
    }];
    
//    NSLog(@"dataarray = %@",dataarray);
//    for ( ICUser * user in dataarray) {
//        NSLog(@"user.photoId = %@,%@",user.photoId,user.eName);
//        if(![ICTools stringEmpty:user.photoId]){
//            NSString *URLstr = MINIMAGEURL(user.photoId);
//            NSLog(@"URLstr = %@",URLstr);
//        }
//    }
//    NSRange range = [urlStr rangeOfString:@"="]; //现获取要截取的字符串位置
//    NSString * result = [urlStr substringFromIndex:range.location+1]; //截取字符串
//    if(result.length < 8){
//    NSLog(@"dataarray.count = %ld",dataarray.count);
    
        switch (dataarray.count) {
            case 1:{
                ICUser * user = dataarray[0];
                NSString *URLstr = MAXIMAGEURL(user.photoId);
                [self addAvatariamgeView:imageView withUrlStr:URLstr witheId:user.eId withName:user.eName];
            }break;
            case 2:
            case 3:
            case 4:{
                [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[self ComposeaddUserArray:dataarray withSize:size] options:SDWebImageRetryFailed];
            }break;
                
            default:
                break;
        }
//    }else{
//        [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage: [UIImage SingleAvatarBuilder:[eId characterAtIndex:eId.length-1]  withName:name withSize:CGSizeMake(100, 100)] options:SDWebImageRetryFailed];
//    }
    
}

//生成群头像
+(UIImage *)GroupHeadgId:(NSString *)gId withSize:(CGSize)size
{
    __block NSMutableArray * dataarray = [[NSMutableArray alloc]init];
    [ICMessageDatabase getUsersWithGroupId:gId limit:4 finish:^(NSArray *array, NSError *error) {
        if(array.count == 0){
            
        }else{
            dataarray = (NSMutableArray *)array;
        }
        
    }];
//    NSLog(@"dataarray.count = %ld",dataarray.count);
    UIImage * image;
    switch (dataarray.count) {
        case 1:{
            ICUser * user = dataarray[0];
            NSString *URLstr = MAXIMAGEURL(user.photoId);
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:URLstr] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
            }];
            NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:URLstr]];
            SDImageCache* cache = [SDImageCache sharedImageCache];
            //此方法会先从memory中取。
            image = [cache imageFromDiskCacheForKey:key];
            if(image == nil)
            {
                image = [self ComposeaddUserArray:dataarray withSize:size];
            }
//            [self addAvatariamgeView:imageView withUrlStr:URLstr witheId:user.eId withName:user.eName];
        }break;
        case 2:
        case 3:
        case 4:{
            image = [self ComposeaddUserArray:dataarray withSize:size];
        }break;
            
        default:
            break;
    }
    return image;

}

+(UIImage *)ComposeaddUser:(ICUser *)user toImage:(ICUser *)user2 withSize:(CGSize)size
{
    UIImage *image1 = [self SingleAvatarBuildereId:[user.eId characterAtIndex:user.eId.length-1]  withName:user.eName withSize:CGSizeMake(size.width/2, size.height) withPiont:CGPointMake(6, 0)];
    UIImage *image2 = [self SingleAvatarBuildereId:[user2.eId characterAtIndex:user2.eId.length-1]  withName:user2.eName withSize:CGSizeMake(size.width/2, size.height) withPiont:CGPointMake(-6, 0)];
    UIGraphicsBeginImageContext(size);
    [image1 drawInRect:CGRectMake(0, 0,size.width/2,size.height)];
    [image2 drawInRect:CGRectMake(size.width/2, 0,size.width/2,size.height)];
    UIImage *Image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return Image;
}

//获取图片
+ (UIImage *)SingleAvatarBuildereId:(NSUInteger)eId withPhotoId:(NSString *)photoId withName:(NSString *)name withSize:(CGSize)size withPiont:(CGPoint)point
{
   if([ICTools stringEmpty:photoId])
   {
       return [self SingleAvatarBuildereId:eId withName:name withSize:size withPiont:point];
   }else{
       NSString * URLstr = MAXIMAGEURL(photoId);
//       UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLstr]]];
       SDWebImageManager *manager = [SDWebImageManager sharedManager];
       [manager downloadImageWithURL:[NSURL URLWithString:URLstr] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
           
       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
           
       }];
       NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:URLstr]];
       SDImageCache* cache = [SDImageCache sharedImageCache];
       //此方法会先从memory中取。
       UIImage * image = [cache imageFromDiskCacheForKey:key];
       if(image != nil)
       {
           if(size.height == size.width){
           }else
           {
               image = [image getImageFromImageRect:CGRectMake(0, 0,size.width, size.height)];
           }
       }else{
           image = [self SingleAvatarBuildereId:eId withName:name withSize:size withPiont:point];
       }
       
       return image;
   }

}

+(UIImage *)ComposeaddUserArray:(NSArray *)userArray withSize:(CGSize)size
{
    if(size.height == 160)
    {
        Wdth = size.height/80;
    }else{
      Wdth = size.height/50;
    }
//    NSLog(@"Wdth = %f",Wdth);
    switch (userArray.count) {
        case 1:
        {
            ICUser *user = userArray[0];
            UIImage *image1 = [self SingleAvatarBuildereId:[user.eId characterAtIndex:user.eId.length-1]  withPhotoId:user.photoId withName:user.eName  withSize:size  withPiont:CGPointMake(0, 0)];
            return image1;
        }break;
        case 2:
        {
            ICUser *user = userArray[0];
            ICUser *user1 = userArray[1];
            UIImage *image1 = [self SingleAvatarBuildereId:[user.eId characterAtIndex:user.eId.length-1]  withPhotoId:user.photoId withName:user.eName  withSize:CGSizeMake(size.width/2-3*Wdth, size.height/2-3*Wdth)  withPiont:CGPointMake(6, 0)];
            UIImage *image2 = [self SingleAvatarBuildereId:[user1.eId characterAtIndex:user1.eId.length-1]  withPhotoId:user1.photoId withName:user1.eName withSize:CGSizeMake(size.width/2-3*Wdth, size.width/2-3*Wdth) withPiont:CGPointMake(-6, 0)];
            UIGraphicsBeginImageContext(size);
            [image1 drawInRect:CGRectMake(Wdth*2, size.height/4+Wdth*1.5,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image2 drawInRect:CGRectMake(size.width/2+Wdth,size.height/4+Wdth*1.5,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            UIImage *Image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return Image;
        }break;
        case 3:
        {
            ICUser *user = userArray[0];
            ICUser *user1 = userArray[1];
            ICUser *user2 = userArray[2];
            UIImage *image1 = [self SingleAvatarBuildereId:[user.eId characterAtIndex:user.eId.length-1]  withPhotoId:user.photoId withName:user.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(6, 0)];
            UIImage *image2 = [self SingleAvatarBuildereId:[user1.eId characterAtIndex:user1.eId.length-1]  withPhotoId:user1.photoId withName:user1.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(-6, 6)];
            UIImage *image3 = [self SingleAvatarBuildereId:[user2.eId characterAtIndex:user2.eId.length-1]  withPhotoId:user2.photoId withName:user2.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(-6, -6)];
            UIGraphicsBeginImageContext(size);
            [image1 drawInRect:CGRectMake(size.width/4+Wdth*1.5,Wdth*2,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image2 drawInRect:CGRectMake(Wdth*2,size.height/2+Wdth,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image3 drawInRect:CGRectMake(size.width/2+Wdth, size.height/2+Wdth,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            UIImage *Image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return Image;
            
        }break;
        case 4:
        {
            ICUser *user = userArray[0];
            ICUser *user1 = userArray[1];
            ICUser *user2 = userArray[2];
            ICUser *user3 = userArray[3];
            UIImage *image1 = [self SingleAvatarBuildereId:[user.eId characterAtIndex:user.eId.length-1]  withPhotoId:user.photoId withName:user.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(6, 6)];
            UIImage *image2 = [self SingleAvatarBuildereId:[user1.eId characterAtIndex:user1.eId.length-1]  withPhotoId:user1.photoId withName:user1.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(-6, 6)];
            UIImage *image3 = [self SingleAvatarBuildereId:[user2.eId characterAtIndex:user2.eId.length-1]  withPhotoId:user2.photoId withName:user2.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(6, -6)];
            UIImage *image4 = [self SingleAvatarBuildereId:[user3.eId characterAtIndex:user3.eId.length-1] withPhotoId:user3.photoId withName:user3.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(-6, -6)];
            UIGraphicsBeginImageContext(size);
            [image1 drawInRect:CGRectMake(Wdth*2, Wdth*2,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image2 drawInRect:CGRectMake(size.height/2+Wdth,Wdth*2,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image3 drawInRect:CGRectMake(Wdth*2, size.width/2+Wdth,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image4 drawInRect:CGRectMake(size.width/2+Wdth, size.height/2+Wdth,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            UIImage *Image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return Image;
            
        }break;
        default:{
            if(userArray.count > 4)
            {
            ICUser *user = userArray[0];
            ICUser *user1 = userArray[1];
            ICUser *user2 = userArray[2];
            ICUser *user3 = userArray[3];
            UIImage *image1 = [self SingleAvatarBuildereId:[user.eId characterAtIndex:user.eId.length-1]  withPhotoId:user.photoId withName:user.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(6, 6)];
            UIImage *image2 = [self SingleAvatarBuildereId:[user1.eId characterAtIndex:user1.eId.length-1]  withPhotoId:user1.photoId withName:user1.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(-6, 6)];
            UIImage *image3 = [self SingleAvatarBuildereId:[user2.eId characterAtIndex:user2.eId.length-1]  withPhotoId:user2.photoId withName:user2.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(6, -6)];
            UIImage *image4 = [self SingleAvatarBuildereId:[user3.eId characterAtIndex:user3.eId.length-1] withPhotoId:user3.photoId withName:user3.eName withSize:CGSizeMake(size.width/2-3*Wdth,size.width/2-3*Wdth) withPiont:CGPointMake(-6, -6)];
            UIGraphicsBeginImageContext(size);
            [image1 drawInRect:CGRectMake(Wdth*2, Wdth*2,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image2 drawInRect:CGRectMake(size.height/2+Wdth,Wdth*2,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image3 drawInRect:CGRectMake(Wdth*2, size.width/2+Wdth,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            [image4 drawInRect:CGRectMake(size.width/2+Wdth, size.height/2+Wdth,size.width/2-3*Wdth,size.width/2-3*Wdth)];
            UIImage *Image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return Image;
            }
            return nil;
        }break;
    }
}




+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];//通过kvo方式给一个字符串，生成二维码
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];//设置二维码的纠错水平，越高纠错水平越高，可以污损的范围越大
    CIImage *outPutImage = [filter outputImage];//拿到二维码图片
    return [[self alloc] createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize waterImageSize:waterImagesize];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size waterImageSize:(CGFloat)waterImagesize{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建一个DeviceGray颜色空间
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    //CGBitmapContextCreate(void * _Nullable data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef  _Nullable space, uint32_t bitmapInfo)
    //width：图片宽度像素
    //height：图片高度像素
    //bitsPerComponent：每个颜色的比特值，例如在rgba-32模式下为8
    //bitmapInfo：指定的位图应该包含一个alpha通道。
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    //创建CoreGraphics image
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    //给二维码加 logo 图
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //logo图
    UIImage *waterimage = [UIImage imageNamed:@"icon_icom_logo"];
    //把logo图画到生成的二维码图片上，注意尺寸不要太大（最大不超过二维码图片的%30），太大会造成扫不出来
    [waterimage drawInRect:CGRectMake((size-waterImagesize)/2.0, (size-waterImagesize)/2.0, waterImagesize, waterImagesize)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}




@end

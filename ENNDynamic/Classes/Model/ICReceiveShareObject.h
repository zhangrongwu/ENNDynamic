//
//  ICReceiveShareObject.h
//  ICome
//
//  Created by zhangrongwu on 16/8/26.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>
// 回调代号
typedef enum {
    IComSuccess           = 0,    /**< 成功    */
    IComErrCodeCommon     = -1,   /**< 普通错误类型    */
    IComErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    IComErrCodeSentFail   = -3,   /**< 发送失败    */
    IComErrCodeUnsupport  = -5,   /**< iCom不支持    */
}IComErrCode;
// 回调类型
typedef enum {
    ICCallBackShare   = 0,   /**< 分享    */
    ICCallBackPay     = 1,   /**< 支付    */
    ICCallBackLogin   = 2,   /**< 集成登录、授权    */
}CallBackAppType;


// 分享类型
typedef enum {
    ICMediaType_Text  = 1,             // 文本
    ICMediaType_Image = 3,             // 图片
    ICMediaType_Video = 4,             // 短视频
    ICMediaType_File  = 5,             // 文件
    ICMediaType_PicURL = 7,            // 图文链接
}ICShareMediaType;

@interface IComMessage : NSObject

/** 标题
 * @note 长度不能超过512字节
 */
@property (nonatomic, strong) NSString *title;
/** 描述内容
 * @note 长度不能超过1K
 */
@property (nonatomic, strong) NSString *desc;
/** 缩略图数据
 * @note 大小不能超过32K
 */
@property (nonatomic, strong) NSData *thumbData;
/** 缩略图url
 * @note 图片url 优先于thumbData (thumUrl没数据时 使用thumData)
 */
@property (nonatomic, strong) NSString *thumUrl;
/** 分享来源
 *  @note from displayName
 */
@property (nonatomic, strong)NSString *displayName;
/** 分享回调schemes
 *  打开第三方app url
 */
@property (nonatomic, strong)NSString *urlSchemes;

@end


/** 网页的url地址
 * @note 不能为空且长度不能超过10K
 */
@interface IComWebpageObject : NSObject

@property (nonatomic, strong) NSString *webpageUrl;

@end


/** 分享图片数组
 * @note 最多9张
 */
@interface IComImageObject : NSObject
// 图片数组 data
@property (nonatomic, strong)NSMutableArray<UIImage *> *imageList;
@property (nonatomic, strong)UIImage *image;
@end


/** 分享文字
 *  @note 文字内容自定义 字数限制（－1）
 */
@interface IComTextObject : NSObject

@property (nonatomic, strong)NSString *text;

@end


/** 分享视频
 *  @note 视频
 */
@interface IComVideoObject : NSObject

@property (nonatomic, strong)NSData *video;

@end


/** 分享文件
 *  @note 文档
 */
@interface IComFileObject : NSObject
// 文件二进制流
@property (nonatomic, strong)NSData *file;
// 文件名称
@property (nonatomic, strong)NSString *fileName;
// 文件后缀(doc、pdf、docx、xls、xlsx、ppt、pptx等类型)
@property (nonatomic, strong)NSString *fileType;
// 用于icom内部分享
@property (nonatomic, strong)NSString *fileKey;

@end


@interface ICReceiveShareObject : NSObject

/** 分享的消息类型
 * @note 图片 文本 图文链接 视频等
 */
@property (nonatomic, assign) NSUInteger mediaType;
@property (nonatomic, strong) NSArray *imageList;
/** 发送消息的多媒体内容
 * @see IComMessage base message
 */
@property (nonatomic, strong)IComMessage *message;
// 文件类型
@property (nonatomic, strong)IComFileObject *fileObject;
// 图文链接类型
@property (nonatomic, strong)IComWebpageObject *webPageObject;
// 图片类型
@property (nonatomic, strong)IComImageObject *imageObject;
// 文本类型
@property (nonatomic, strong)IComTextObject *textObject;
// 视频类型
@property (nonatomic, strong)IComVideoObject *videoObject;

/** 发送的目标场景，可以选择发送到会话(IComSession)或者朋友圈(IComTimeline)。
 *  默认发送到会话。
 * @see IComScene
 */
@property (nonatomic, assign) int scene;

-(instancetype)initWithDict:(NSDictionary *)queryDict;
/** @brief 该方法用于回调第三方应用
 *
 *
 *  @param type     回调类型(分享、支付、集成登录等)
 *  @param scheme   回调url
 *  @param Errcode  IComErrCode 回调类型
 *  @param errorStr 回调提示内容
 */
+(void)callBackAppType:(CallBackAppType)type
        callBackScheme:(NSString *)urlScheme
               ErrCode:(IComErrCode)Errcode
              errorStr:(NSString *)errorStr;

@end





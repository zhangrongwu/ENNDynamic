//
//  ICReceiveShareObject.m
//  ICome
//
//  Created by zhangrongwu on 16/8/26.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICReceiveShareObject.h"
#import "NSString+Base64.h"
#import "NSString+Extension.h"
@implementation ICReceiveShareObject

-(instancetype)initWithDict:(NSDictionary *)queryDict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:queryDict];
        self.message.title = [NSString decodeString:queryDict[@"title"]];
        self.message.desc = [NSString decodeString:queryDict[@"desc"]];
        if (queryDict[@"thumbData"]) {
            self.message.thumbData = [[NSData alloc] initWithBase64EncodedString:[NSString decodeString:queryDict[@"thumbData"]] options:0];
        }
        
        //        if (queryDict[@"jsThumbData"]) {
        //            self.message.thumbData =[[NSData alloc] initWithBase64EncodedString:queryDict[@"jsThumbData"] options:0];
        //        }
        
        if (queryDict[@"jsThumbUrl"]) {
            self.message.thumUrl = [NSString decodeString:queryDict[@"thumbUrl"]];
        }
        
        self.message.displayName = [NSString decodeString:queryDict[@"displayName"]];
        self.message.urlSchemes = [NSString decodeString:queryDict[@"urlSchemes"]];
        if (queryDict[@"shareType"]) {
            self.mediaType = [queryDict[@"shareType"] integerValue];
        }
        switch (self.mediaType) {
            case ICMediaType_Text: {
                self.textObject.text = [NSString decodeString:queryDict[@"text"]];
            }
                break;
            case ICMediaType_Image: {
                //                NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:[queryDict[@"imageList"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                //
                //                for (NSString *encodedImageStr in jsonObject) {
                //                    NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:encodedImageStr options:0];
                //                    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
                //                    [self.imageObject.imageList addObject:decodedImage];
                //                }
                
                NSData *decodedImageData = [[NSData alloc] initWithBase64EncodedString:[NSString decodeString:queryDict[@"image"]] options:0];
                self.imageObject.image = [UIImage imageWithData:decodedImageData];
            }
                break;
            case ICMediaType_Video: {
                self.videoObject.video = [[NSData alloc] initWithBase64EncodedString:[NSString decodeString:queryDict[@"video"]] options:0];
            }
                break;
            case ICMediaType_File: {
                self.fileObject.fileName = queryDict[@"fileName"];
                self.fileObject.fileType = queryDict[@"fileType"];//queryDict[@"fifileTypele"];
                self.fileObject.fileKey  = queryDict[@"fileKey"];
                self.fileObject.file = [[NSData alloc] initWithBase64EncodedString:[NSString decodeString:queryDict[@"file"]] options:0];
            }
                break;
            case ICMediaType_PicURL: {
                self.webPageObject.webpageUrl = [NSString decodeString:queryDict[@"webpageUrl"]];
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if ([key isEqualToString:@"shareType"]) {
//        self.mediaType = [value integerValue];
//    }
}

+(void)callBackAppType:(CallBackAppType)type
        callBackScheme:(NSString *)urlScheme
               ErrCode:(IComErrCode)Errcode
              errorStr:(NSString *)errorStr {
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@://",urlScheme]];
    [mutableStr appendString:[NSString stringWithFormat:@"respType=%d&", type]];
    [mutableStr appendString:[NSString stringWithFormat:@"respCode=%d&", Errcode]];
    [mutableStr appendString:[NSString stringWithFormat:@"respString=%@&", errorStr]];
    NSString *encoded = [[mutableStr copy] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encoded]];
}

-(IComMessage *)message {
    if (!_message) {
        _message = [[IComMessage alloc] init];
    }
    return _message;
}

-(IComTextObject *)textObject {
    if (!_textObject) {
        _textObject = [[IComTextObject alloc] init];
    }
    return _textObject;
}

-(IComImageObject *)imageObject {
    if (!_imageObject) {
        _imageObject = [[IComImageObject alloc] init];
    }
    return _imageObject;
}

-(IComVideoObject *)videoObject {
    if (!_videoObject) {
        _videoObject = [[IComVideoObject alloc] init];
    }
    return _videoObject;
}

-(IComWebpageObject *)webPageObject {
    if (!_webPageObject) {
        _webPageObject = [[IComWebpageObject alloc] init];
    }
    return _webPageObject;
}

-(IComFileObject *)fileObject {
    if (!_fileObject) {
        _fileObject = [[IComFileObject alloc] init];
    }
    return _fileObject;
}

@end

@implementation IComFileObject

@end

@implementation IComWebpageObject

@end

@implementation IComVideoObject

@end

@implementation IComImageObject
-(NSMutableArray<UIImage *> *)imageList {
    if (!_imageList) {
        _imageList = [[NSMutableArray alloc] init];
    }
    return _imageList;
}

@end

@implementation IComTextObject

@end

@implementation IComMessage

@end

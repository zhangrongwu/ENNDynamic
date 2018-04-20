//
//  ICBaseDataController.h
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^ICCompletionCallback)(NSError *error);
typedef void (^MessageHandle)(id message);
typedef void(^Progress)(NSProgress *pro);

@interface ICBaseDataController : NSObject

@end

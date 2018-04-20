//
//  ICUser.h
//  ICome
//
//  Created by ENN on 16/3/29.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICUser : NSObject

// 用户ID
@property (nonatomic, copy) NSString *eId;

// 用户名
@property (nonatomic, copy) NSString *eName;

// 新增 用户的头像photoid
@property (nonatomic, copy) NSString *photoId;

// 昵称
@property (nonatomic, copy) NSString *nName;

// 头像URL
//@property (nonatomic, copy) NSString *headURL;

// 性别
//@property (nonatomic, copy) NSString *sex;

// 手机号
@property (nonatomic, copy) NSString *phone;

// 办公手机号
@property (nonatomic, copy) NSString *mobile;

// 邮箱
@property (nonatomic, copy) NSString *email;

// 职务
@property (nonatomic, copy) NSString *jobTitle;

// 组织ID
@property (nonatomic, copy) NSString *oId;

// 部门名称
@property (nonatomic, copy) NSString *oName;

// 账号
@property (nonatomic, copy) NSString *account;


// 人员状态，其实不应该加到这里的，后台强制定的
@property (nonatomic, assign) BOOL valid;




//account = dingyisheng;
//eId = 10029843;
//eName = "\U4e01\U4ebf\U751f";
//email = "DINGYISHENG@ENN.CN";
//jobTitle = "\U8f6f\U4ef6\U5f00\U53d1\U4e2d\U7ea7\U5de5\U7a0b\U5e08-IT";
//mobile = 18519395235;
//oId = 50106381;
//oName = "\U5e94\U7528\U6280\U672f\U90e8";
//password = "<null>";
//phone = 13701355535;
//

// 当前用户
+ (ICUser *)currentUser;
+ (void)releaseUser;
+ (void)updateUserInfo;

+ (void)saveCurrentUserInfor:(NSDictionary *)info;





@end

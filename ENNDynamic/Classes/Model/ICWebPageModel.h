//
//  ICWebPageModel.h
//  ICome
//
//  Created by zhangrongwu on 16/8/30.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICWebPageModel : NSObject
@property (nonatomic, strong)NSString *url;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *photoId;
@property (nonatomic, strong)NSString *from;

@property (nonatomic, strong)NSString *fromDesc;

-(instancetype)initWithMedialKeys:(NSArray *)keys;


@end

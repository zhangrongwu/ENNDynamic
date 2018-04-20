//
//  ICPicModel.h
//  ICome
//
//  Created by zhangrongwu on 16/5/10.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPicModel : NSObject

@property (nonatomic, strong) NSString *url; // image url
@property (nonatomic, assign) int width; // pic width
@property (nonatomic, assign) int height; //< pic height
@property (nonatomic, strong)NSString *imageKey;
@property (nonatomic, strong)NSMutableArray *picInfoList;
-(instancetype)initWithMedialKeys:(NSArray *)keys;
@end

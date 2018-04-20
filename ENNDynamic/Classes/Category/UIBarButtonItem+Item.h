//
//  UIBarButtonItem+Item.h
//  ICome
//
//  Created by chenqs on 2017/7/25.
//  Copyright © 2017年 iCom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,UIBarButtonItemType){
    
    UIBarButtonItemTypeLeft = 1,
    UIBarButtonItemTypeRight
};

@interface UIBarButtonItem (Item)

///图片
+ (instancetype)barButtonItemWithImageName:(NSString *)imageName itemType:(UIBarButtonItemType)type target:(id)target action:(SEL)action;

///文字
+ (instancetype)barButtonItemWithTitle:(NSString *)title itemType:(UIBarButtonItemType)type target:(id)target action:(SEL)action;

@end

//
//  UIBarButtonItem+Item.m
//  ICome
//
//  Created by chenqs on 2017/7/25.
//  Copyright © 2017年 iCom. All rights reserved.
//

#import "UIBarButtonItem+Item.h"
#import "EnnDynamicHeader.h"
@implementation UIBarButtonItem (Item)


+ (instancetype)barButtonItemWithImageName:(NSString *)imageName itemType:(UIBarButtonItemType)type target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44., 44.);
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (type == UIBarButtonItemTypeLeft) {
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    }else
    {
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    }
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


+ (instancetype)barButtonItemWithTitle:(NSString *)title itemType:(UIBarButtonItemType)type target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44., 44.);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = ICFont(15);
    if (type == UIBarButtonItemTypeLeft) {
        if (title.length > 2) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -3, 0, -15);
        }else
        {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
        }
    }else
    {
        if (title.length > 2) {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, -3);
        }else
        {
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -16);
        }
    }
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}


@end

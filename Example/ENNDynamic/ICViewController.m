//
//  ICViewController.m
//  ENNDynamic
//
//  Created by zhangrongwu on 04/20/2018.
//  Copyright (c) 2018 zhangrongwu. All rights reserved.
//

#import "ICViewController.h"

@interface ICViewController ()

@end

@implementation ICViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(10, 155, self.view.frame.size.width - 2 * 10, 50);
    [btn setTitle:@"打开" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)messageBtnClick {
    
//    ICMailViewController *vc = [[ICMailViewController alloc] initWithEmailHostName:@"webmail.xinaogroup.com" userId:@"10045111" Account:@"zhangrongwu@ennew.cn" passWord:@"zhangrongwu1"];
//
//    [self.navigationController pushViewController:vc animated:YES];
}


@end

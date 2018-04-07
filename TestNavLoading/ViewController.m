//
//  ViewController.m
//  TestNavLoading
//
//  Created by wyh on 2018/4/3.
//  Copyright © 2018年 Wyh. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+WyhLoading.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"主页";
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Left" style:(UIBarButtonItemStylePlain) target:self action:@selector(leftAction)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Right" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
}


- (void)leftAction {
    
    [self.navigationController showLoading];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.navigationController dismissLoadingWithErrorMsg:@"No net"];
//    });
    
}

- (void)rightAction {
    
//    [self.navigationController pushViewController:[TestViewController new] animated:YES];
    
    
    [self.navigationController dismissLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

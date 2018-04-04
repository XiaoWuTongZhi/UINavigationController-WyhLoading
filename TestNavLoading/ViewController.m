//
//  ViewController.m
//  TestNavLoading
//
//  Created by wyh on 2018/4/3.
//  Copyright © 2018年 Wyh. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+HSLoading.h"
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
}

- (void)rightAction {
    
    [self.navigationController dismissLoadingWithErrorMsg:@"无网络"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

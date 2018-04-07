//
//  TestViewController.m
//  TestNavLoading
//
//  Created by wyh on 2018/4/7.
//  Copyright © 2018年 Wyh. All rights reserved.
//

#import "TestViewController.h"
#import "UINavigationController+WyhLoading.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Second";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Right" style:(UIBarButtonItemStylePlain) target:self action:@selector(rightAction)];
    
    [self.navigationController showLoading];
    
}

- (void)rightAction {
    
    [self.navigationController dismissLoading];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

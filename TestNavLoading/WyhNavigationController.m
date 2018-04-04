//
//  WyhNavigationController.m
//  TestNavLoading
//
//  Created by wyh on 2018/4/3.
//  Copyright © 2018年 Wyh. All rights reserved.
//

#import "WyhNavigationController.h"

@interface WyhNavigationController ()

@end

@implementation WyhNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)currentActivityViewController {
    if (self.viewControllers.count <= 0) {
        return nil;
    }
    return self.viewControllers.lastObject;
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

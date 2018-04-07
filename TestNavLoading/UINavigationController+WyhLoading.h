//
//  UINavigationController+WyhLoading.h
//  TestNavLoading
//
//  Created by wyh on 2018/4/7.
//  Copyright © 2018年 Wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (WyhLoading)


- (void)showLoading;

- (void)dismissLoadingWithErrorMsg:(NSString *)msg;

- (void)dismissLoading;

@end

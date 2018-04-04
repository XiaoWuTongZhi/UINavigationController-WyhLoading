//
//  UINavigationController+HSLoading.h
//  TestNavLoading
//
//  Created by wyh on 2018/4/3.
//  Copyright © 2018年 Wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (HSLoading)

@property (nonatomic, strong, readonly) UIActivityIndicatorView *indicator;

- (UIViewController *)currentActivityViewController;

- (UIView *)navigationBarContentView;

- (UILabel *)titleLabel;

- (void)showLoading;

- (void)dismissLoadingWithErrorMsg:(NSString *)msg;

- (void)dismissLoading;

@end

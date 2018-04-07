//
//  UINavigationController+WyhLoading.m
//  TestNavLoading
//
//  Created by wyh on 2018/4/7.
//  Copyright © 2018年 Wyh. All rights reserved.
//

#import "UINavigationController+WyhLoading.h"
#import <objc/runtime.h>

#define wyh_swizzleMethod(oneSel,anotherSel) \
Method oneMethod = class_getInstanceMethod(self, oneSel); \
Method anotherMethod = class_getInstanceMethod(self, anotherSel); \
method_exchangeImplementations(oneMethod, anotherMethod); \

static NSString * const _UINavigationBarContentViewClass = @"_UINavigationBarContentView";

static CGFloat const _IndicatorAndTitleLabelMargin = 2.f;

static NSString * _lastNavTitle;
static BOOL _isNavIndicatorLoading;

@interface UINavigationController ()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation UINavigationController (WyhLoading)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wyh_swizzleMethod(@selector(viewDidLayoutSubviews), @selector(wyh_viewDidLayoutSubviews));
        
        {
            wyh_swizzleMethod(@selector(pushViewController:animated:), @selector(wyh_pushViewController:animated:));
        }
        {
            wyh_swizzleMethod(@selector(popViewControllerAnimated:), @selector(wyh_popViewControllerAnimated:));
        }
    });
    
}

#pragma mark - UI

- (void)initializeUI {
    
    if (!self.indicator) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        indicator.hidesWhenStopped = YES;
        [indicator sizeToFit];
        self.indicator = indicator;
    }
    
}

- (void)layoutIndicatorIfNeeded {
    
    UIView *contentView = [self navigationBarContentView];
    
    if (![contentView.subviews containsObject:self.indicator]) {
        [contentView addSubview:self.indicator];
    }
    
    if ([self titleLabel].text.length != 0) {
        self.indicator.frame = CGRectMake([self titleLabel].frame.origin.x - _IndicatorAndTitleLabelMargin - self.indicator.bounds.size.width, contentView.center.y - self.indicator.bounds.size.height/2, self.indicator.bounds.size.width, self.indicator.bounds.size.height);
    }else {
        
        self.indicator.center = contentView.center;
    }
}

#pragma mark - rewrite

- (void)wyh_viewDidLayoutSubviews {
    
//    if (_isNavIndicatorLoading) {
//        [self titleLabel].text = @"Loading...";
//        [self layoutIndicatorIfNeeded];
//    }
    
//    [self wyh_viewDidLayoutSubviews];
}

- (void)wyh_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (_isNavIndicatorLoading) {
        [self dismissLoading];
    }
    [self wyh_pushViewController:viewController animated:animated];
}

- (UIViewController *)wyh_popViewControllerAnimated:(BOOL)animated {
    
    if (_isNavIndicatorLoading) {
        [self dismissLoading];
    }
    return [self wyh_popViewControllerAnimated:animated];
}

#pragma mark - Api

- (void)showLoading {
    
    [self showLoadingWithMsg:@"Loading..."];
}

- (void)showLoadingWithMsg:(NSString *)msg {
    
    if (_isNavIndicatorLoading) {
        NSLog(@"Navigation's indicator already loading.");
        return;
    }
    _isNavIndicatorLoading = YES;
    
    _lastNavTitle = [self currentActivityViewController].title;
    
    [self currentActivityViewController].title = msg;
    
    [self initializeUI];
    
    [self.indicator startAnimating];
    
    [self layoutIndicatorIfNeeded];
}

- (void)dismissLoading {
    
    if (!_isNavIndicatorLoading) {
        NSLog(@"Navigation's indicator already dismiss.");
        return;
    }
    [self dismissLoadingWithTitleMsg:_lastNavTitle];
    [self clean];
}

- (void)dismissLoadingWithErrorMsg:(NSString *)msg {
    
    [self dismissLoadingWithTitleMsg:[NSString stringWithFormat:@"(%@)%@",msg,_lastNavTitle?:@""]];
}

- (void)dismissLoadingWithTitleMsg:(NSString *)msg {
    
    UILabel *titleLabel = [self titleLabel];
    if (titleLabel != nil) {
        titleLabel.text = msg;
        [titleLabel sizeToFit];
    }
    
    if (!self.indicator) {
        NSLog(@"current navigation controller doesn't contain indicator.");
        return;
    }
    
    [self.indicator stopAnimating];
    
    _isNavIndicatorLoading = NO;
    
}

- (void)clean {
    
    _lastNavTitle = @"";
    
}

#pragma mark - Hierarchy

- (UIViewController *)currentActivityViewController {
    if (self.viewControllers.count <= 0) {
        return nil;
    }
    return self.viewControllers.lastObject;
}

- (UIView *)navigationBarContentView {
    
    __block UIView *_NavigationBarContentView ;
    
    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull _barSubView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_barSubView isKindOfClass:NSClassFromString(_UINavigationBarContentViewClass)]) {
            _NavigationBarContentView = _barSubView;
            *stop = YES;
        }
    }];
    
    if (_NavigationBarContentView == nil) {
        NSAssert(NO, @"Can not find the _UINavigationBarContentView, plz check the Hierarchy !");
    }
    
    return _NavigationBarContentView;
    
}

- (UILabel *)titleLabel {
    
    __block UIView *NavigationContentView = [self navigationBarContentView];
    __block UILabel *NavigationTitleLabel;
    
    if (NavigationContentView.subviews.count == 0) {
        NSLog(@"No title label in this navigationBar");
        return nil;
    }
    
    [NavigationContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull _barContentSubView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([_barContentSubView isKindOfClass:[UILabel class]]) {
            NavigationTitleLabel = _barContentSubView;
            *stop = YES;
        }
    }];
    
    return NavigationTitleLabel;
    
}



#pragma mark - Getter

- (void)setIndicator:(UIActivityIndicatorView *)indicator {
    objc_setAssociatedObject(self, @selector(indicator), indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)indicator {
    return objc_getAssociatedObject(self, _cmd);
}

@end

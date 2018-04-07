//
//  UINavigationController+HSLoading.m
//  TestNavLoading
//
//  Created by wyh on 2018/4/3.
//  Copyright © 2018年 Wyh. All rights reserved.
//

#import "UINavigationController+HSLoading.h"

#import <objc/runtime.h>

static NSString * const _UINavigationBarContentViewClass = @"_UINavigationBarContentView";

static CGFloat const _IndicatorAndTitleLabelMargin = 5.f;

static NSString * _lastNavTitle;
static BOOL _isNavIndicatorLoading;

@interface UINavigationController ()

@property (nonatomic, strong) UILabel *customLabel;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UIView *titleView;

@end

@implementation UINavigationController (HSLoading)


- (void)initializeUI {
    
    if (!self.indicator) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        indicator.hidesWhenStopped = YES;
        [indicator sizeToFit];
        self.indicator = indicator;
    }
    if (!self.titleView) {
        UIView *titleView = [[UIView alloc]init];
        self.titleView = titleView;
    }
    if (!self.customLabel) {
        UILabel *titleLabel = [self titleLabel];
        if (!titleLabel) {
            // default style.
            UILabel *customLabel = [[UILabel alloc]init];
            customLabel.textColor = [UIColor blackColor];
            customLabel.font = [UIFont boldSystemFontOfSize:17.f];
            customLabel.backgroundColor = [UIColor clearColor];
            self.customLabel = customLabel;
        }else {
            UILabel *customTitleLabel = [[UILabel alloc]init];
            customTitleLabel.textColor = titleLabel.textColor;
            customTitleLabel.font = titleLabel.font;
            customTitleLabel.backgroundColor = titleLabel.backgroundColor;
            self.customLabel = customTitleLabel;
        }
    }
    
}

#pragma mark - API

- (void)showLoading {
    
    if (_isNavIndicatorLoading) {
        NSLog(@"Navigation's indicator already loading.");
        return;
    }
    _isNavIndicatorLoading = YES;
    
    _lastNavTitle = self.title;
    
    UILabel *titleLabel = [self titleLabel];
    if (titleLabel != nil) {
        titleLabel.text = nil;
    }
    
    [self initializeUI];
    
    self.customLabel.text = @"Loading...";
    [self.customLabel sizeToFit];
    
    [self.indicator startAnimating];
    
    [self layoutTitleViewIfNeeded];
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
    
    if (self.customLabel) {
        self.customLabel.text = @"";
        [self.titleView removeFromSuperview];
    }
    
    if (!self.indicator) {
        NSLog(@"current navigation controller doesn't contain indicator.");
        return;
    }
    
    [self.indicator stopAnimating];
    
    [self layoutTitleLabelIfNeeded];
    
    _isNavIndicatorLoading = NO;
    
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

#pragma mark - Methods

- (void)layoutTitleViewIfNeeded {
    
    if (!self.titleView) {
        NSAssert(NO, @"titleView doesn't exit.");
    }
    
    UIView *contentView = [self navigationBarContentView];
    
    if (![contentView.subviews containsObject:self.titleView]) {
        [contentView addSubview:self.titleView];
    }
    
    [self layoutIndicatorIfNeeded];
    [self layoutTitleLabelIfNeeded];
    
    CGFloat titleViewWidth;
    if (_isNavIndicatorLoading) {
        titleViewWidth = self.customLabel.bounds.size.width + _IndicatorAndTitleLabelMargin + self.indicator.bounds.size.width;
    }else {
        titleViewWidth = self.customLabel.bounds.size.width;
    }
    self.titleView.bounds = CGRectMake(0, 0, titleViewWidth, contentView.bounds.size.height);
    self.titleView.center = contentView.center;
    
}

- (void)layoutIndicatorIfNeeded {
    
    UIView *contentView = [self navigationBarContentView];
    
    UIView *titleView = self.titleView;
    
    if (![titleView.subviews containsObject:self.indicator]) {
        [titleView addSubview:self.indicator];
    }
    
    if (self.customLabel.text == nil || [self.customLabel.text isEqual: @""]) {
        self.indicator.frame = CGRectMake(0, contentView.center.y - self.indicator.bounds.size.height/2, self.indicator.bounds.size.width, self.indicator.bounds.size.height);
    }else {
        
//        CGFloat maxTitleWidth = self.customLabel.bounds.size.width + _IndicatorAndTitleLabelMargin + self.indicator.bounds.size.width;
        CGFloat centerY = contentView.center.y;
//        (contentView.bounds.size.width - maxTitleWidth)/2
        self.indicator.frame = CGRectMake(0, centerY - self.indicator.bounds.size.height/2, self.indicator.bounds.size.width, self.indicator.bounds.size.height);
    }
}

- (void)layoutTitleLabelIfNeeded {
    
//    UILabel *titleLabel = [self titleLabel];
    UIView *contentView = [self navigationBarContentView];
    
    UILabel *customTitleLabel = self.customLabel;
    
    if (!self.customLabel) {
        return;
    }
    
    if (![self.titleView.subviews containsObject:self.customLabel]) {
        [self.titleView addSubview:self.customLabel];
    }
    
    if (_isNavIndicatorLoading) {
        
        CGFloat centerY = contentView.bounds.size.height/2;
        CGFloat indicatorWidth , indicatorHeight;
        indicatorWidth = indicatorHeight = self.indicator.bounds.size.width;
        
        CGFloat maxTitleWidth = customTitleLabel.bounds.size.width + _IndicatorAndTitleLabelMargin + indicatorWidth;
        
        if (maxTitleWidth > contentView.bounds.size.width) {
            NSLog(@"Over width");
            return;
        }
        // Update frames.
        customTitleLabel.frame = CGRectMake(self.indicator.frame.origin.x + indicatorWidth + _IndicatorAndTitleLabelMargin, centerY - customTitleLabel.bounds.size.height/2, customTitleLabel.bounds.size.width, customTitleLabel.bounds.size.height);
        
        
        
    }else {
        // Indicator dismissed.
        CGRect labelFrame = customTitleLabel.frame;
        labelFrame.origin.x = 0;
        labelFrame.origin.y = contentView.bounds.size.height/2 - customTitleLabel.bounds.size.height/2;
        customTitleLabel.frame = labelFrame;
    }
}

- (void)clean {
    
    _lastNavTitle = @"";
    
}

#pragma mark - Getter

- (void)setIndicator:(UIActivityIndicatorView *)indicator {
    objc_setAssociatedObject(self, @selector(indicator), indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)indicator {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setTitleView:(UIView *)titleView {
    objc_setAssociatedObject(self, @selector(titleView), titleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)titleView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCustomLabel:(UILabel *)customLabel {
    objc_setAssociatedObject(self, @selector(customLabel), customLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)customLabel {
    return objc_getAssociatedObject(self, _cmd);
}

@end

//
//  JapanAlertView.m
//  launcher
//
//  Created by williamzhang on 16/4/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanAlertView.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface JapanAlertView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, copy) JapanAlertClickedBlock clickBlock;

@end

@implementation JapanAlertView

+ (instancetype)alertViewImage:(UIImage *)image
                         title:(NSString *)title
                      subTitle:(NSString *)subTitle
                 buttonsTitles:(NSArray *)buttonsTitles
{
    JapanAlertView *alertView = [[JapanAlertView alloc] init];
    alertView.frame = [alertView screenFrame];
    UIView *contentView = alertView.contentView;
    UIView *lastView = nil;
    
    if (image) {
        [alertView.imageView setImage:image];
        [contentView addSubview:alertView.imageView];
        [alertView.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@75);
            make.top.equalTo(contentView).offset(20);
            make.centerX.equalTo(contentView);
        }];
        
        lastView = alertView.imageView;
    }
    
    if ([title length]) {
        [contentView addSubview:alertView.titleLabel];
        alertView.titleLabel.text = title;
        [alertView.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(contentView).offset(20);
            make.right.lessThanOrEqualTo(contentView).offset(-20);
            make.centerX.equalTo(contentView).priorityHigh();
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(20);
            }
            else {
                make.top.equalTo(contentView).offset(20);
            }
        }];
        
        lastView = alertView.titleLabel;
    }
    
    if ([subTitle length]) {
        [contentView addSubview:alertView.subTitleLabel];
        alertView.subTitleLabel.text = subTitle;
        [alertView.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(contentView).offset(20);
            make.right.lessThanOrEqualTo(contentView).offset(-20);
            make.centerX.equalTo(contentView).priorityHigh();
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(20);
            }
            else {
                make.top.equalTo(contentView).offset(20);
            }
        }];
        
        lastView = alertView.subTitleLabel;
    }
    
    UIButton *lastButton = nil;
    for (NSInteger i = 0; i < [buttonsTitles count]; i ++)
    {
        UIButton *button = [alertView buttonWithTitle:buttonsTitles[i] index:i];
        [contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@45);
            make.bottom.equalTo(contentView);
            
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(20);
            } else {
                make.top.equalTo(contentView);
            }
            
            if (lastButton) {
                make.width.equalTo(lastButton);
                make.left.equalTo(lastButton.mas_right);
            } else {
                make.left.equalTo(contentView);
            }
            
            if (i + 1 == [buttonsTitles count]) {
                make.right.equalTo(contentView);
            }
        }];
        
        lastButton = button;
    }
    
    if (!lastButton) {
        return alertView;
    }
    
    UIView *line = [UIView new];
    [contentView addSubview:line];
    line.backgroundColor = [UIColor borderColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.height.equalTo(@0.5);
        make.top.equalTo(lastButton);
    }];
    
    for (NSInteger i = 0; i < [buttonsTitles count] - 1; i ++) {
        UIView *seperator = [UIView new];
        [contentView addSubview:seperator];
        seperator.backgroundColor = [UIColor borderColor];
        [seperator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.top.equalTo(lastButton);
            make.width.equalTo(@0.5);
            make.right.equalTo(contentView).multipliedBy((i + 1.0) / [buttonsTitles count]);
        }];
    }
    
    return alertView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.backgroundView];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(40);
            make.right.equalTo(self).offset(-40);
        }];
    }
    return self;
}

- (void)clickAtIndex:(JapanAlertClickedBlock)clickedBlock {
    self.clickBlock = clickedBlock;
}

- (void)show {
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
}

#pragma mark - Button Click
- (void)clickedAtIndex:(UIButton *)sender {
    !self.clickBlock ?: self.clickBlock(sender.tag);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Private Method
- (UIButton *)buttonWithTitle:(NSString *)title index:(NSInteger)index {
    UIButton *button = [UIButton new];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor themeBlue] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    button.tag = index;
    [button addTarget:self action:@selector(clickedAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (CGRect)screenFrame {
    return [[UIScreen mainScreen] bounds];
}

#pragma mark - Initializer
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:[self screenFrame]];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _backgroundView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.layer.cornerRadius = 10;
        _contentView.clipsToBounds = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont mtc_font_30];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = [UIFont mtc_font_28];
        _subTitleLabel.textColor = [UIColor blackColor];
        _subTitleLabel.numberOfLines = 0;
    }
    return _subTitleLabel;
}

@end

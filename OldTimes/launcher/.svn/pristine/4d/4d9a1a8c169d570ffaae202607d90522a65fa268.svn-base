//
//  JapanRegisterProgress.m
//  launcher
//
//  Created by williamzhang on 16/4/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanRegisterProgress.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface JapanRegisterProgress ()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation JapanRegisterProgress

- (instancetype)initWithTotalProgress:(NSUInteger)progress {
    self = [super initWithFrame:CGRectMake(0, 0, 0, 45)];
    if (self) {
        
        UIView *contentView = [UIView new];
        [self addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(50);
            make.right.equalTo(self).offset(-50);
            make.top.bottom.equalTo(self);
        }];
        
        for (NSInteger i = 0; i < progress; i ++) {
            UIButton *cornerButton = [self cornerButtonWithTag:i * 2];
            [contentView addSubview:cornerButton];
            [self.buttonArray addObject:cornerButton];
            
            if (i + 1 != progress) {
                UIButton *lineButton = [self lineButtonWithTag:2 * i + 1];
                [contentView addSubview:lineButton];
                [self.buttonArray addObject:lineButton];
            }
        }
        
        [self initConstraints];
    }
    return self;
}

- (void)initConstraints {
    
    UIView *lastView = nil;
    
    UIView *lastLineView = nil;
    
    for (NSInteger i = 0; i < [self.buttonArray count]; i ++) {
        UIButton *button = [self.buttonArray objectAtIndex:i];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(button.superview);
            
            if (i % 2 == 0) {
                // 圆
                make.width.height.equalTo(@11);
            }
            else {
                if (!lastLineView) {
                    make.height.equalTo(@2);
                }
                else {
                    make.width.height.equalTo(lastLineView);
                }
            }
            
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(8);
            }
            else {
                make.left.equalTo(button.superview);
            }
            
            if (i + 1 == [self.buttonArray count] ) {
                make.right.equalTo(button.superview);
            }
            
        }];
        
        lastView = button;
        if (i % 2 == 1) {
            lastLineView = button;
        }
    }
}

#pragma mark - Interface Method
- (void)setProgress:(NSUInteger)progress {
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = obj.tag <= progress * 2 ;
    }];
}

#pragma mark - Create
- (UIButton *)cornerButtonWithTag:(NSInteger)tag {
    UIButton *button = [UIButton new];
    
    UIImage *image = [UIImage mtc_imageColor:[UIColor minorFontColor] size:CGSizeMake(11, 11) cornerRadius:5];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    
    button.tintColor = [UIColor themeBlue];
    
    button.tag = tag;
    button.userInteractionEnabled = NO;
    
    return button;
}

- (UIButton *)lineButtonWithTag:(NSInteger)tag {
    UIButton *button = [UIButton new];
    
    UIImage *image = [UIImage mtc_imageColor:[UIColor minorFontColor]];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    button.tintColor = [UIColor themeBlue];
    
    button.tag = tag;
    button.userInteractionEnabled = NO;
    
    return button;
}

#pragma mark - Initializer
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end

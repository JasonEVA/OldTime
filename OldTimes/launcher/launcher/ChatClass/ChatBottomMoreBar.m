//
//  ChatBottomMoreBar.m
//  launcher
//
//  Created by williamzhang on 16/3/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatBottomMoreBar.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface ChatBottomMoreBar ()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation ChatBottomMoreBar

- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles {
    NSAssert(images.count == titles.count, @"错误❌");
    
    self = [super init];
    if (self) {
      
        UIView *lastView;
        for (NSInteger i = 0; i < [images count]; i ++) {
            UIImage *image = [images objectAtIndex:i];
            NSString *title = [titles objectAtIndex:i];
            
            UIButton *button = [self buttonTitle:title image:image];
            button.tag = i;
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self);
                if (lastView) {
                    make.left.equalTo(lastView.mas_right);
                    make.width.equalTo(lastView);
                } else {
                    make.left.equalTo(self);
                }
                
                if (i == [images count] - 1) {
                    make.right.equalTo(self);
                }
            }];
            
            lastView = button;
            [self.buttonArray addObject:button];
        }
        
        UIView *topSeperatorLine = [UIView new];
        topSeperatorLine.backgroundColor = [UIColor borderColor];
        [self addSubview:topSeperatorLine];
        
        [topSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    
    return self;
}

#pragma mark - Interface Method
- (void)canTapButtons:(BOOL)canTap {
    [self.buttonArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = canTap;
    }];
}

- (void)setTitleEmphsisButtonWithTitle:(NSString *)title Image:(UIImage*)image
{
    UIButton *btn = self.buttonArray[0];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
}

#pragma mark - Button Click
- (void)clickedAtButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(chatBottomMoreBar:clickedAtIndex:)]) {
        [self.delegate chatBottomMoreBar:self clickedAtIndex:sender.tag];
    }
}

#pragma mark - Create
- (UIButton *)buttonTitle:(NSString *)title image:(UIImage *)image {
    UIButton *button = [UIButton new];
    
    button.layer.borderColor = [UIColor mtc_colorWithW:194].CGColor;
    button.layer.borderWidth = 0.5;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    
    [button.titleLabel setFont:[UIFont mtc_font_30]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor themeBlue] forState:UIControlStateSelected];
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    
    button.tintColor = [UIColor themeBlue];
    
    [button addTarget:self action:@selector(clickedAtButton:) forControlEvents:UIControlEventTouchUpInside];
    
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

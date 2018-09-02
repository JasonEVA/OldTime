//
//  BaseSelectTableViewCell.m
//  launcher
//
//  Created by williamzhang on 16/3/31.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseSelectTableViewCell.h"

#define LEFTSELECT_BUTTON_WIDTH 22

NSString *const wz_default_tableViewCell_identifier = @"wz_default_tableViewCell_identifier";

@interface BaseSelectTableViewCell ()

@property (nonatomic, strong) UIButton *leftSelectButton;
@property (nonatomic, assign) BOOL wz_editing;

@end

@implementation BaseSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.wz_contentView];
    }
    return self;
}

- (UIEdgeInsets)wz_leftSelectButtonInsets {
    return UIEdgeInsetsMake(0, 12, 0, 0);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.wz_editing) {
        self.wz_contentView.frame = self.contentView.frame;
        return;
    }
    
    CGRect contentViewFrame = self.contentView.frame;

    self.leftSelectButton.frame = CGRectMake(self.wz_leftSelectButtonInsets.left, self.wz_leftSelectButtonInsets.top, LEFTSELECT_BUTTON_WIDTH, LEFTSELECT_BUTTON_WIDTH);
    
    if (self.wz_leftSelectButtonInsets.top == 0) {
        CGPoint leftButtonCenter = self.leftSelectButton.center;
        leftButtonCenter.y = CGRectGetHeight(contentViewFrame) / 2;
        self.leftSelectButton.center = leftButtonCenter;
    }
    
    CGFloat wzContentView_X = CGRectGetMaxX(self.leftSelectButton.frame) + 8;
    
    self.wz_contentView.frame = CGRectMake(wzContentView_X, 0, CGRectGetWidth(contentViewFrame) - wzContentView_X, CGRectGetHeight(contentViewFrame));
}

#pragma mark - Override Method
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:NO animated:animated];
    [self setWz_editing:editing];
    [self setWz_selected:self.wz_selected];
}

#pragma mark - Private Method
- (void)changeModeIfNeed {
    if (self.wz_editing) {
        if (_leftSelectButton) {
            return;
        }
        
        [self.contentView addSubview:self.leftSelectButton];
        self.leftSelectButton.frame = [self hidingLeftButtonFrame];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }];
        return;
    }
    
    else {
        // 不是编辑状态
        if (!_leftSelectButton) {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.leftSelectButton.frame = [self hidingLeftButtonFrame];
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (!self.wz_editing) {
                [self.leftSelectButton removeFromSuperview];
                _leftSelectButton = nil;
            }
        }];
    }
}

/// 隐藏状态时的center
- (CGRect)hidingLeftButtonFrame {
    CGFloat frame_y = self.wz_leftSelectButtonInsets.top;
    if (frame_y == 0) {
        frame_y = (CGRectGetHeight(self.contentView.frame ) - LEFTSELECT_BUTTON_WIDTH) / 2;
    }
    
    CGRect frame = CGRectMake(-LEFTSELECT_BUTTON_WIDTH, frame_y, LEFTSELECT_BUTTON_WIDTH, LEFTSELECT_BUTTON_WIDTH);
    return frame;
}

- (void)clearSelect {
    _wz_selected = NO;
    _leftSelectButton.selected = NO;
}

#pragma mark Setter & Getter
- (void)setWz_editing:(BOOL)wz_editing {
    _wz_editing = wz_editing;
    if (!wz_editing) {
        [self clearSelect];
    }
    [self changeModeIfNeed];
}

- (void)setWz_selected:(BOOL)wz_selected {
    _wz_selected = wz_selected;
    if (self.wz_editing) {
        _leftSelectButton.selected = _wz_selected;
    }
}

#pragma mark - Initializer
@synthesize wz_contentView = __wz_contentView;
- (UIView *)wz_contentView {
    if (!__wz_contentView) {
        __wz_contentView = [UIView new];
        __wz_contentView.backgroundColor = [UIColor clearColor];
    }
    return __wz_contentView;
}

- (UIButton *)leftSelectButton {
    if (!_leftSelectButton) {
        _leftSelectButton = [UIButton new];
        [_leftSelectButton setImage:[UIImage imageNamed:@"Me_uncheck"] forState:UIControlStateNormal];
        [_leftSelectButton setImage:[UIImage imageNamed:@"Me_check"] forState:UIControlStateSelected];
        [_leftSelectButton setImage:[UIImage imageNamed:@"check_gray"] forState:UIControlStateDisabled];
        _leftSelectButton.userInteractionEnabled = NO;
    }
    return _leftSelectButton;
}

@end

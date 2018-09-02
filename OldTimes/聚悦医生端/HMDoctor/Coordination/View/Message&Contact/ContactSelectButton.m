//
//  ContactSelectButton.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ContactSelectButton.h"

@interface ContactSelectButton ()
@property (nonatomic, strong)  UIImageView  *selectImageView; // <##>
@property (nonatomic, strong)  UIView  *bottomLine; // <##>
@end

@implementation ContactSelectButton

- (instancetype)initWithEdit:(BOOL)edit isShowTopLine:(BOOL)isShowTopLine
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.isShowTopLine = isShowTopLine;
        self.selectable = edit;
        [self configElements];
        
    }
    return self;
}

- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    self.button.tag = tag;
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        _selected = selected;
        
        [self.selectImageView setImage:selected ? [UIImage imageNamed:@"c_contact_selected"] : [UIImage imageNamed:@"c_contact_unselected"]];
    }
}

// 设置元素控件
- (void)configElements {
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    if (self.selectable) {
        [self addSubview:self.selectImageView];
        [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(12.5);
            make.width.equalTo(self.selectImageView.mas_height);
        }];
        
    }
    [self addSubview:self.button];
    [self addSubview:self.bottomLine];
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectable ? self.selectImageView.mas_right : self).offset(12.5);
        make.top.bottom.right.equalTo(self);
    }];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    if (self.isShowTopLine) {
        UIView *line = [UIView new];
        [line setBackgroundColor:[UIColor systemLineColor_c8c7cc]];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
    }
}

// 设置数据
- (void)configData {

}

- (void)configSelectState {
    self.selected = !self.selected;
    
    if ([self.delegate respondsToSelector:@selector(contactSelectButtonDelegateCallBack_selectedStateChangedWithView:selected:)]) {
        [self.delegate contactSelectButtonDelegateCallBack_selectedStateChangedWithView:self selected:self.selected];
    }

}

#pragma mark - Init

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.clipsToBounds = YES;
        [_selectImageView setImage:[UIImage imageNamed:@"c_contact_unselected"]];
        _selectImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(configSelectState)];
        [_selectImageView addGestureRecognizer:gesture];
    }
    return _selectImageView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
        [_button.titleLabel setFont:[UIFont font_30]];
    }
    return _button;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = [UIColor systemLineColor_c8c7cc];
    }
    return _bottomLine;
}

@end

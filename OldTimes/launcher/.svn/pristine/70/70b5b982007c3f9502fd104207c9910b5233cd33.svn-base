//
//  ChatEmptyView.m
//  launcher
//
//  Created by williamzhang on 16/2/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatEmptyView.h"
#import <Masonry/Masonry.h>
#import "UnifiedUserInfoManager.h"
#import "Category.h"
#import "MyDefine.h"

@interface ChatEmptyView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *subTipLabel;

@end

@implementation ChatEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.imageView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.subTipLabel];
        
        [self initConstraints];
    }
    return self;
}

- (void)initConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@[self, self.tipLabel, self.subTipLabel]);
        make.bottom.equalTo(self.tipLabel.mas_top).offset(-20);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(-30);
    }];
    
    [self.subTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(20);
        make.bottom.lessThanOrEqualTo(self).priorityHigh();
        make.left.right.equalTo(self.tipLabel);
    }];
}

#pragma mark - Creater
- (UILabel *)labelWithTitle:(NSString *)title {
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.font = [UIFont mtc_font_30];
    label.textColor = [UIColor mtc_colorWithHex:0xacacac];
    label.text = title;
    return label;
}

#pragma mark - Initializer
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"empty_chat"];
        _imageView = [[UIImageView alloc] initWithImage:image];
    }
    return _imageView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [self labelWithTitle:LOCAL(CHAT_EMPTY_TIP)];
    }
    return _tipLabel;
}

- (UILabel *)subTipLabel {
    if (!_subTipLabel) {
        _subTipLabel = [self labelWithTitle:[NSString stringWithFormat:LOCAL(CHAT_EMPTY_SUBTIP), [[UnifiedUserInfoManager share] companyCode]]];
    }
    return _subTipLabel;
}

@end

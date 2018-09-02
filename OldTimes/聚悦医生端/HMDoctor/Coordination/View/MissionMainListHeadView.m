//
//  MissionMainListHeadView.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionMainListHeadView.h"
#import "UIImage+EX.h"
#import <Masonry/Masonry.h>

@interface MissionMainListHeadView()
@property (nonatomic, copy) MissionMainListHeadViewBlock selectBlock;
@end

@implementation MissionMainListHeadView
- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.titelLb];
        [self addSubview:self.selectButton];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
        }];
        
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.width.equalTo(@60);
            make.height.equalTo(@23);
            make.right.equalTo(self).offset(-12);
        }];
    }
    return self;
}

- (void)btnClick
{
    self.selectButton.selected ^= 1;
    if (self.selectBlock) {
        self.selectBlock(self.selectButton.selected,self.selectButton.tag);
    }
    
}

- (void)selectClickBlock:(MissionMainListHeadViewBlock)block
{
    self.selectBlock = block;
}
- (UIButton *)selectButton
{
    if (!_selectButton) {
        _selectButton = [UIButton new];
        [_selectButton setTitle:@"显示全部" forState:UIControlStateNormal];
        [_selectButton setTitle:@"收起" forState:UIControlStateSelected];
        [_selectButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_selectButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_selectButton.layer setCornerRadius:3];
        [_selectButton setClipsToBounds:YES];
        [_selectButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (UILabel *)titelLb
{
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor commonDarkGrayColor_666666]];
        [_titelLb setText:@"已过期"];
        [_titelLb setFont:[UIFont systemFontOfSize:12]];
        
    }
    return _titelLb;
}
@end

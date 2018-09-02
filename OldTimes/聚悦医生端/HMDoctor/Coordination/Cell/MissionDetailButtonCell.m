//
//  MissionDetailButtonCell.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionDetailButtonCell.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>

@interface MissionDetailButtonCell ()
@property (nonatomic, strong) UIButton *acceptBtn;
@property (nonatomic, strong) UIButton *refuseBtn;
@property (nonatomic, copy) MissionDetailButtonCellBlock clickBlock;
@end

@implementation MissionDetailButtonCell
+ (NSString *)identifier { return NSStringFromClass([self class]);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.acceptBtn];
        [self.contentView addSubview:self.refuseBtn];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@120);
            make.height.equalTo(@30);
            make.right.equalTo(self.contentView.mas_centerX).offset(-20);
        }];
        
        [self.refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.width.height.equalTo(self.acceptBtn);
            make.left.equalTo(self.contentView.mas_centerX).offset(20);
        }];
    }
    return self;
}

- (void)clickMyBtnBlock:(MissionDetailButtonCellBlock)block
{
    self.clickBlock = block;
}

- (void)click:(UIButton *)btn
{
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
}

- (UIButton *)getMyBtnWithTitel:(NSString *)titel color:(UIColor *)color tag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:titel forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn.layer setCornerRadius:3];
    [btn.layer setBorderWidth:1];
    [btn.layer setBorderColor:color.CGColor];
    [btn setTag:tag];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIButton *)acceptBtn
{
    if (!_acceptBtn) {
        _acceptBtn = [self getMyBtnWithTitel:@"接受" color:[UIColor colorWithHex:0x44ca7c] tag:1];
    }
    return _acceptBtn;
}

- (UIButton *)refuseBtn
{
    if (!_refuseBtn) {
        _refuseBtn = [self getMyBtnWithTitel:@"拒绝" color:[UIColor colorWithHex:0xff3366] tag:0];
    }
    return _refuseBtn;
}
@end

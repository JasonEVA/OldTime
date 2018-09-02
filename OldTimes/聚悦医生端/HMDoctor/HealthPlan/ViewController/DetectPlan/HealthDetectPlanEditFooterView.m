//
//  HealthDetectPlanEditFooterView.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthDetectPlanEditFooterView.h"

@implementation HealthDetectPlanEditFooterView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self showTopLine];
        [self layoutElements];
    }
    return self;
}

- (void) layoutElements
{
    [self.descendingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12.5);
        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(64, 25));
    }];
    
    [self.ascendingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.descendingButton.mas_left).offset(-10);
        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(64, 25));
    }];
    
    [self.appendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ascendingButton.mas_left).offset(-10);
        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(64, 25));
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.appendButton.mas_left).offset(-10);
        make.centerY.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(64, 25));
    }];
}

- (UIButton*) deleteButton
{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_deleteButton];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_deleteButton setImage:[UIImage imageNamed:@"icon_healthplan_delete"] forState:UIControlStateNormal];
        
    }
    return _deleteButton;
}

- (UIButton*) appendButton
{
    if (!_appendButton) {
        _appendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_appendButton];
        [_appendButton setTitle:@"预警" forState:UIControlStateNormal];
        [_appendButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
        [_appendButton setTitleColor:[UIColor commonLightGrayTextColor] forState:UIControlStateDisabled];
        [_appendButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_appendButton setImage:[UIImage imageNamed:@"icon_healthplan_add"] forState:UIControlStateNormal];
        
    }
    return _appendButton;
}

- (UIButton*) ascendingButton
{
    if (!_ascendingButton) {
        _ascendingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_ascendingButton];
        [_ascendingButton setTitle:@"排序" forState:UIControlStateNormal];
        [_ascendingButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
        [_ascendingButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_ascendingButton setImage:[UIImage imageNamed:@"icon_healthplan_up"] forState:UIControlStateNormal];
        
    }
    return _ascendingButton;
}

- (UIButton*) descendingButton
{
    if (!_descendingButton) {
        _descendingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_descendingButton];
        [_descendingButton setTitle:@"排序" forState:UIControlStateNormal];
        [_descendingButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
        [_descendingButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_descendingButton setImage:[UIImage imageNamed:@"icon_healthplan_down"] forState:UIControlStateNormal];
        
    }
    return _descendingButton;
}
@end

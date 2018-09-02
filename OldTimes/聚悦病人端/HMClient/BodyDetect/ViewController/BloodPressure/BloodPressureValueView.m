//
//  BloodPressureValueView.m
//  HMClient
//
//  Created by lkl on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodPressureValueView.h"

@interface BloodPressureValueView ()
{
    UILabel *lbName;
    UILabel *lbChildName;
    UILabel *lbBoodPressureValue;
    UILabel *lbUnit;
}
@end

@implementation BloodPressureValueView


- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        //291  左108  右182
        lbName = [[UILabel alloc]init];
        [self addSubview:lbName];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:18]];
        [lbName setTextColor:[UIColor colorWithHexString:@"666666"]];
        
        lbChildName = [[UILabel alloc] init];
        [self addSubview:lbChildName];
        [lbName setFont:[UIFont systemFontOfSize:13]];
        [lbName setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        lbBoodPressureValue = [[UILabel alloc] init];
        [self addSubview:lbBoodPressureValue];
        [lbBoodPressureValue setFont:[UIFont systemFontOfSize:30]];
        [lbBoodPressureValue setTextColor:[UIColor blackColor]];
        
        lbUnit = [[UILabel alloc] init];
        [self addSubview:lbUnit];
        [lbName setFont:[UIFont systemFontOfSize:13]];
        [lbName setTextColor:[UIColor colorWithHexString:@"333333"]];
        
        [self subviewLayout];
    }
    
    return self;
}

- (void) subviewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(self.mas_height);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

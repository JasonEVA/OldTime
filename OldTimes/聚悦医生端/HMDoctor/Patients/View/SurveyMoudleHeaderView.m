//
//  SurveyMoudleHeaderView.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SurveyMoudleHeaderView.h"

@interface SurveyMoudleHeaderView ()
{
    UIImageView* ivArrow;
    UILabel* lbIllName;
}
@end

@implementation SurveyMoudleHeaderView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:ivArrow];
        [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(7, 13));
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
        }];
        
        lbIllName = [[UILabel alloc]init];
        [self addSubview:lbIllName];
        [lbIllName setFont:[UIFont systemFontOfSize:15]];
        [lbIllName setTextColor:[UIColor commonTextColor]];
        [lbIllName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).with.offset(12.5);
            make.right.lessThanOrEqualTo(ivArrow.mas_left);
        }];
        
        [self showBottomLine];
    }
    return self;
}

- (void) setIllName:(NSString*) name
{
    [lbIllName setText:name];
}

- (void) setIsSelected:(BOOL) isSelected
{
    if (isSelected)
    {
        [ivArrow setImage:[UIImage imageNamed:@"c_arrow_down"]];
        [ivArrow mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(13, 7));
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
        }];
    }
    else
    {
        [ivArrow setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [ivArrow mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(7, 13));
            make.right.equalTo(self).with.offset(-12.5);
            make.centerY.equalTo(self);
        }];
    }
}

@end

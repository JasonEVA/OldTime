//
//  HealthHistoryHeaderView.m
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthHistoryHeaderView.h"

@interface HealthHistoryHeaderView ()
{
    UIView* yearControl;
    UILabel* lbYear;
    UIImageView* ivArrow;
    UIView* lineview;
}

@end

@implementation HealthHistoryHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        lineview = [[UIView alloc]init];
        [lineview setBackgroundColor:[UIColor mainThemeColor]];
        [self addSubview:lineview];
        
        yearControl = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 59, 22)];
        [self addSubview:yearControl];
        [yearControl setUserInteractionEnabled:NO];
        yearControl.layer.cornerRadius = yearControl.height/2;
        yearControl.layer.masksToBounds = YES;
        [yearControl setBackgroundColor:[UIColor mainThemeColor]];
        
        lbYear = [[UILabel alloc]init];
        [yearControl addSubview:lbYear];
        [lbYear setBackgroundColor:[UIColor clearColor]];
        [lbYear setTextColor:[UIColor whiteColor]];
        [lbYear setFont:[UIFont systemFontOfSize:11]];
        
        ivArrow = [[UIImageView alloc]init];
        [yearControl addSubview:ivArrow];
        //history_expended
        [ivArrow setImage:[UIImage imageNamed:@"history_expended"]];
        
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [yearControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@22);
        make.width.mas_equalTo(@59);
        make.left.equalTo(self).with.offset(13);
        make.centerY.equalTo(self);
    }];
    
    [lbYear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yearControl).with.offset(7);
        make.centerY.equalTo(yearControl);
    }];
    
    [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@8);
        make.width.mas_equalTo(@8);
        make.centerY.equalTo(yearControl);
        make.right.equalTo(yearControl).with.offset(-8);
    }];
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.width.mas_equalTo(@1);
        make.top.equalTo(self);
        make.left.equalTo(self).with.offset(51);
    }];
}

- (void) setYearStr:(NSString *)yearStr
{
    _yearStr = yearStr;
    [lbYear setText:yearStr];
}

- (void) setIsExtended:(BOOL)isExtended
{
    _isExtended = isExtended;
    if (_isExtended)
    {
        [ivArrow setImage:[UIImage imageNamed:@"history_expended"]];
    }
    else
    {
        [ivArrow setImage:[UIImage imageNamed:@"history_disexpended"]];
    }
}

@end

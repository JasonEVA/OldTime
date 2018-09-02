//
//  PrescribeListStartTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PrescribeListStartTableViewCell.h"

@interface PrescribeListStartTableViewCell ()
{
    UIView  *statesView;
    UILabel *lbState;
    UILabel *lbCreateTime;
    UILabel *lbStaffDesc;
}
@end

@implementation PrescribeListStartTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        statesView = [[UIView alloc] init];
        [self addSubview:statesView];
        [statesView setBackgroundColor:[UIColor commonGrayTextColor]];
        
        lbState = [[UILabel alloc] init];
        [self addSubview:lbState];
        [lbState setNumberOfLines:0];
        [lbState setTextAlignment:NSTextAlignmentCenter];
        [lbState setTextColor:[UIColor whiteColor]];
        [lbState setFont:[UIFont systemFontOfSize:12]];
        
        lbCreateTime = [[UILabel alloc] init];
        [self addSubview:lbCreateTime];
        [lbCreateTime setTextColor:[UIColor commonTextColor]];
        [lbCreateTime setFont:[UIFont systemFontOfSize:14]];
        
        lbStaffDesc = [[UILabel alloc] init];
        [self addSubview:lbStaffDesc];
        [lbStaffDesc setTextColor:[UIColor commonTextColor]];
        [lbStaffDesc setFont:[UIFont systemFontOfSize:14]];
        
        _buttonCopy = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_buttonCopy];
        [_buttonCopy.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_buttonCopy setTitle:@"复制建议" forState:UIControlStateNormal];
        [_buttonCopy setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [statesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(15);
    }];
    
    [lbState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(statesView);
        make.left.and.top.equalTo(statesView);
    }];
    
    [lbCreateTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statesView.mas_right).with.offset(10);
        make.top.equalTo(self).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
    
    [lbStaffDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statesView.mas_right).with.offset(10);
        make.top.equalTo(lbCreateTime.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(240, 20));
    }];
    
    [_buttonCopy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        make.centerY.height.equalTo(self);
        make.width.mas_equalTo(70);
    }];
}

- (void)setPrescribeInfo:(PrescribeInfo *)info
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *inputDate = [formatter dateFromString:info.createTime];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *timeStr = [formatter stringFromDate:inputDate];
    
    if (info)
    {
        [lbCreateTime setText:timeStr];
        [lbStaffDesc setText:info.staffDesc];
    }

    if ([info.status isEqualToString:@"C"])
    {
        [lbState setText:@"执行中"];
        [_buttonCopy setHidden:YES];
        [statesView setBackgroundColor:[UIColor mainThemeColor]];
        
    }else if([info.status isEqualToString:@"R"])
    {
        [lbState setText:@"已停止"];
        [_buttonCopy setHidden:NO];
        [statesView setBackgroundColor:[UIColor commonGrayTextColor]];
    }else
    {
        [lbState setText:@""];
    }
}

@end

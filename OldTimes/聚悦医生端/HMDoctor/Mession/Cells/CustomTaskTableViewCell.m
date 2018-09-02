//
//  CustomTaskTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CustomTaskTableViewCell.h"

@interface CustomTaskTableViewCell ()
{
    UIView  *taskView;
    UILabel *lbPatient;
    UILabel *lbMessage;
    UILabel *lbPlanTime;
    UILabel *lbtime;
    UIImageView *ivIcon;//
}
@end

@implementation CustomTaskTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        
        taskView = [[UIView alloc] init];
        [self addSubview:taskView];
        [taskView setBackgroundColor:[UIColor whiteColor]];
        [taskView.layer setCornerRadius:3.0f];
        [taskView.layer setMasksToBounds:YES];
        
        lbPatient = [[UILabel alloc] init];
        [taskView addSubview:lbPatient];
        [lbPatient setTextColor:[UIColor commonTextColor]];
        [lbPatient setFont:[UIFont systemFontOfSize:15]];
        
        lbMessage = [[UILabel alloc] init];
        [taskView addSubview:lbMessage];
        [lbMessage setTextColor:[UIColor commonGrayTextColor]];
        [lbMessage setFont:[UIFont systemFontOfSize:14]];
        
        lbPlanTime = [[UILabel alloc] init];
        [taskView addSubview:lbPlanTime];
        [lbPlanTime setText:@"计划时间:"];
        [lbPlanTime setTextColor:[UIColor commonGrayTextColor]];
        [lbPlanTime setFont:[UIFont systemFontOfSize:14]];
        
        lbtime = [[UILabel alloc] init];
        [taskView addSubview:lbtime];
        [lbtime setTextColor:[UIColor commonGrayTextColor]];
        [lbtime setFont:[UIFont systemFontOfSize:14]];
        
        ivIcon = [[UIImageView alloc] init];
        [taskView addSubview:ivIcon];
        
        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.height.mas_equalTo(95);
    }];
    
    [lbPatient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(taskView).with.offset(5);
        make.top.equalTo(taskView).with.offset(12);
        make.right.equalTo(taskView);
        make.height.mas_equalTo(20);
    }];
    
    [lbMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(taskView).with.offset(5);
        make.top.equalTo(lbPatient.mas_bottom).with.offset(5);
        make.right.equalTo(taskView);
        make.height.mas_equalTo(20);
    }];
    
    [lbPlanTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(taskView).with.offset(5);
        make.top.equalTo(lbMessage.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(65, 20));
    }];
    
    [lbtime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPlanTime.mas_right).with.offset(5);
        make.top.equalTo(lbMessage.mas_bottom).with.offset(5);
        make.right.equalTo(taskView);
        make.height.mas_equalTo(20);
    }];
    
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(taskView.mas_right);
        make.top.equalTo(taskView.mas_bottom).with.offset(-24);
        make.size.mas_equalTo(CGSizeMake(44, 24));
    }];
}

- (void)setUserScheduleInfo:(UserScheduleInfo *)info
{
    if (info)
    {
        [lbPatient setText:info.scheduleTitle];
        [lbMessage setText:info.scheduleCon];
        [lbtime setText:info.beginTime];
    }
    
    if ([info.status isEqualToString:@"R"])
    {
        [ivIcon setImage:[UIImage imageNamed:@"icon_task_overdue"]];
    }
}

@end

//
//  MainStartTeamStaffCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartTeamStaffCell.h"

@interface MainStartTeamStaffCell ()
{
    UIImageView* ivStaff;
    UIImageView* ivLeader;
    UILabel* lbStaffName;
    UILabel* lbStaffTitle;
}
@end

@implementation MainStartTeamStaffCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ivStaff = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default_staff"]];
        [self addSubview:ivStaff];
        ivStaff.layer.cornerRadius = 55.0/2;
        ivStaff.layer.masksToBounds = YES;
        
        [ivStaff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(55, 55));
            make.centerY.equalTo(self.mas_top).with.offset(40);
        }];
        
        ivLeader = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_ggroup_leader"]];
        [ivStaff addSubview:ivLeader];
        [ivLeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ivStaff);
            make.bottom.equalTo(ivStaff);
            make.width.mas_equalTo(@61);
        }];
        [ivLeader setHidden:YES];
        
        lbStaffName = [[UILabel alloc]init];
        [self addSubview:lbStaffName];
        [lbStaffName setFont:[UIFont systemFontOfSize:15]];
        [lbStaffName setTextColor:[UIColor whiteColor]];
        
        [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(76);
        }];
        
        lbStaffTitle = [[UILabel alloc]init];
        [self addSubview:lbStaffTitle];
        [lbStaffTitle setFont:[UIFont systemFontOfSize:12]];
        [lbStaffTitle setTextColor:[UIColor whiteColor]];
        
        [lbStaffTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(lbStaffName.mas_bottom).with.offset(2);
        }];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setIsTeamLeader:(BOOL) isLeader
{
    [ivStaff mas_updateConstraints:^(MASConstraintMaker *make) {
        if (isLeader)
        {
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }
        else
        {
            make.size.mas_equalTo(CGSizeMake(55, 55));
        }
    }];
    
    if (isLeader)
    {
        ivStaff.layer.cornerRadius = 35;
    }
    else
    {
        ivStaff.layer.cornerRadius = 55/2;
    }
    
    [ivLeader setHidden:!isLeader];
}

- (void) setStaffInfo:(StaffInfo*) staff
{
    [lbStaffName setText:staff.staffName];
    [lbStaffTitle setText:staff.teamStaffTypeName];
    
    if (staff.imgUrl)
    {
        [ivStaff sd_setImageWithURL:[NSURL URLWithString:staff.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_default_staff"]];
    }
}

@end

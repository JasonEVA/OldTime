//
//  HMStaffInfoCollectionViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMStaffInfoCollectionViewCell.h"
#define ICONHEIGHT     50
@interface HMStaffInfoCollectionViewCell ()
{
    UIImageView* ivStaff;
    UILabel* ivLeader;
    UILabel* lbStaffName;
    UILabel* lbStaffTitle;
}
@end

@implementation HMStaffInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        ivStaff = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default_staff"]];
        [self.contentView addSubview:ivStaff];
        ivStaff.layer.cornerRadius = ICONHEIGHT/2;
        [ivStaff setClipsToBounds:YES];
        
        [ivStaff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.equalTo(@ICONHEIGHT);
            make.width.equalTo(@ICONHEIGHT);
        }];
        
        ivLeader = [[UILabel alloc]init];
        [ivLeader setText:@"首席"];
        [ivLeader setBackgroundColor:[UIColor mainThemeColor]];
        [ivLeader setTextAlignment:NSTextAlignmentCenter];
        [ivLeader setFont:[UIFont systemFontOfSize:10]];
        [ivLeader setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [ivStaff addSubview:ivLeader];
        [ivLeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(ivStaff);
            make.bottom.equalTo(ivStaff);
        }];
        [ivLeader setHidden:YES];
        
        lbStaffName = [[UILabel alloc]init];
        [self.contentView addSubview:lbStaffName];
        [lbStaffName setFont:[UIFont systemFontOfSize:15]];
        [lbStaffName setTextColor:[UIColor colorWithHexString:@"333333"]];
        [lbStaffName setTextAlignment:NSTextAlignmentCenter];
        [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ivStaff);
            make.top.equalTo(ivStaff.mas_bottom).offset(7);
            make.right.lessThanOrEqualTo(self.contentView);
        }];
        
        lbStaffTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbStaffTitle];
        [lbStaffTitle setFont:[UIFont systemFontOfSize:12]];
        [lbStaffTitle setTextColor:[UIColor colorWithHexString:@"999999"]];
        
        [lbStaffTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(ivStaff);
            make.top.equalTo(lbStaffName.mas_bottom).with.offset(5);
            make.right.lessThanOrEqualTo(self.contentView);
//            make.bottom.lessThanOrEqualTo(self.contentView).offset(-10);
        }];

    }
    return self;
}


- (void) setIsTeamLeader:(BOOL) isLeader
{
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

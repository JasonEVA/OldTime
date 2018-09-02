//
//  AppointmentSelectStaffCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentSelectStaffCell.h"

@interface AppointmentSelectStaffCell ()
{
    UIImageView* ivStaff;
    UIImageView* ivSelect;
    UILabel* lbIsLeader;
    UILabel* lbStaffName;
    UILabel* lbStaffType;
}
@end

@implementation AppointmentSelectStaffCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ivStaff = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default_staff"]];
        [self addSubview:ivStaff];
        ivStaff.layer.cornerRadius = 50.0/2;
        ivStaff.layer.masksToBounds = YES;
        
        ivSelect = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_appint_selected"]];
        [self addSubview:ivSelect];
        [ivSelect setHidden:YES];
        
        lbIsLeader = [[UILabel alloc]init];
        [ivStaff addSubview:lbIsLeader];
        [lbIsLeader setBackgroundColor:[UIColor commonRedColor]];
        [lbIsLeader setTextColor:[UIColor whiteColor]];
        [lbIsLeader setFont:[UIFont systemFontOfSize:8]];
        [lbIsLeader setTextAlignment:NSTextAlignmentCenter];
        [lbIsLeader setText:@"团队长"];
        
        lbStaffName = [[UILabel alloc]init];
        [self addSubview:lbStaffName];
        [lbStaffName setFont:[UIFont font_30]];
        [lbStaffName setTextColor:[UIColor commonTextColor]];
        
        lbStaffType = [[UILabel alloc]init];
        [self addSubview:lbStaffType];
        [lbStaffType setFont:[UIFont font_24]];
        [lbStaffType setTextColor:[UIColor commonGrayTextColor]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(13);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [ivSelect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ivStaff);
        make.top.equalTo(ivStaff);
        make.size.mas_equalTo(CGSizeMake(13, 13));
    }];
    
    [lbIsLeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ivStaff);
        make.height.mas_equalTo(@15);
        make.left.and.right.equalTo(ivStaff);
    }];
    
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(ivStaff.mas_bottom).with.offset(5);
    }];
    
    [lbStaffType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(lbStaffName.mas_bottom).with.offset(2);
    }];
}

- (void) setStaffInfo:(AppointStaffModel*) staff
{
    [lbStaffName setText:staff.staffName];
    [lbStaffType setText:staff.staffTypeName];
    
    if (staff.imgUrl)
    {
        [ivStaff sd_setImageWithURL:[NSURL URLWithString:staff.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_default_staff"]];
    }

}

- (void) setIsTeamLeader:(BOOL) isLeader
{
    [lbIsLeader setHidden:!isLeader];
}

- (void) setIsSelected:(BOOL) selected
{
    [ivSelect setHidden:!selected];
}
@end

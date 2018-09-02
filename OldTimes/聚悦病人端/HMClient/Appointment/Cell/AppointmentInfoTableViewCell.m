//
//  AppointmentInfoTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentInfoTableViewCell.h"

@interface AppointmentInfoTableViewCell ()
{
    UIView* statusview;
    UIImageView* ivFlag;
    UILabel* lbStatus;
    UILabel* lbApplyType;
    
    UILabel* lbApplyDateTitle;
    UILabel* lbAddressTitle;
    UILabel* lbStaffTitle;
    UILabel* lbNoticeTitle;
    
    UILabel* lbApplyDate;
    UILabel* lbAddress;
    UILabel* lbStaff;
    UILabel* lbNotice;
    
    UIView* bottomview;
}
@end

@implementation AppointmentInfoTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        statusview = [[UIView alloc]init];
        [self.contentView addSubview:statusview];
        [statusview showBottomLine];
        
        ivFlag = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_list_line"]];
        [statusview addSubview:ivFlag];
        
        lbStatus = [[UILabel alloc]init];
        [statusview addSubview:lbStatus];
        [lbStatus setFont:[UIFont font_30]];
        [lbStatus setTextColor:[UIColor mainThemeColor]];
        
        lbApplyType = [[UILabel alloc]init];
        [statusview addSubview:lbApplyType];
        [lbApplyType setFont:[UIFont font_28]];
        [lbApplyType setTextColor:[UIColor commonGrayTextColor]];
        
        lbApplyDateTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbApplyDateTitle];
        [lbApplyDateTitle setFont:[UIFont font_28]];
        [lbApplyDateTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbApplyDateTitle setText:@"就诊时间:"];
        
        lbApplyDate = [[UILabel alloc]init];
        [self.contentView addSubview:lbApplyDate];
        [lbApplyDate setFont:[UIFont font_28]];
        [lbApplyDate setTextColor:[UIColor commonTextColor]];
        
        lbAddressTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbAddressTitle];
        [lbAddressTitle setFont:[UIFont font_28]];
        [lbAddressTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbAddressTitle setText:@"就诊地点:"];
        
        lbAddress = [[UILabel alloc]init];
        [self.contentView addSubview:lbAddress];
        [lbAddress setFont:[UIFont font_28]];
        [lbAddress setTextColor:[UIColor commonTextColor]];
        
        lbStaffTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbStaffTitle];
        [lbStaffTitle setFont:[UIFont font_28]];
        [lbStaffTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbStaffTitle setText:@"医生:"];
        
        lbStaff = [[UILabel alloc]init];
        [self.contentView addSubview:lbStaff];
        [lbStaff setFont:[UIFont font_28]];
        [lbStaff setTextColor:[UIColor commonTextColor]];
        
        lbNoticeTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbNoticeTitle];
        [lbNoticeTitle setFont:[UIFont font_28]];
        [lbNoticeTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbNoticeTitle setText:@"附加信息:"];
        
        lbNotice = [[UILabel alloc]init];
        [self.contentView addSubview:lbNotice];
        [lbNotice setFont:[UIFont font_28]];
        [lbNotice setTextColor:[UIColor commonTextColor]];
        
        bottomview = [[UIView alloc]init];
        [bottomview setBackgroundColor:[UIColor commonBackgroundColor]];
        [self.contentView addSubview:bottomview];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [statusview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
        make.height.mas_equalTo(40);
    }];
    
    [ivFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(statusview);
        make.left.equalTo(statusview).with.offset(12.5);
        make.size.mas_equalTo(CGSizeMake(2, 14));
    }];

    [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivFlag.mas_right).with.offset(4);
        make.centerY.equalTo(statusview);
    }];
    
    [lbApplyType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.centerY.equalTo(statusview);
    }];
    
    [lbApplyDateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(statusview.mas_bottom).with.offset(10);
    }];
    
    [lbApplyDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbApplyDateTitle.mas_right);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(lbApplyDateTitle);
    }];
    
    [lbAddressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbApplyDateTitle.mas_bottom).with.offset(10);
    }];
    
    [lbAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbAddressTitle.mas_right);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(lbAddressTitle);
    }];
    
    [lbStaffTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbAddressTitle.mas_bottom).with.offset(10);
    }];
    
    [lbStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbStaffTitle.mas_right);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(lbStaffTitle);
    }];
    
    [lbNoticeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbStaffTitle.mas_bottom).with.offset(10);
    }];
    
    [lbNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbNoticeTitle.mas_right);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(lbNoticeTitle);
    }];
    
    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@5);
    }];
}

- (void) setAppointmentInfo:(AppointmentInfo*) appoint
{
    [lbStatus setText:[appoint statusString]];
    [lbApplyType setText:appoint.doWayStr];
    
    [lbApplyDate setText:appoint.appointTime];
    [lbAddress setText:appoint.appointAddr];
    NSString* staffStr = appoint.staffName;
    NSString* expendStr = [appoint staffExpendString];
    if (expendStr && 0 < expendStr.length)
    {
        if (!staffStr)
        {
            staffStr = expendStr;
        }
        else
        {
            staffStr = [staffStr stringByAppendingString:expendStr];
        }
    }
    [lbStaff setText:staffStr];
    [lbNotice setText:@""];
    if (appoint.noticeCon && 0 < appoint.noticeCon.length) {
        [lbNotice setText:appoint.noticeCon];
    }
}


@end

//
//  UserAppointmentTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserAppointmentTableViewCell.h"

@interface UserAppointmentTableViewCell ()
{
    UIImageView* ivPartrait;
   
}
@end

@implementation UserAppointmentTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        appointmentview = [[UIView alloc]init];
        [appointmentview setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:appointmentview];
        [appointmentview.layer setBorderColor:[UIColor commonControlBorderColor].CGColor];
        [appointmentview.layer setBorderWidth:0.5];
        [appointmentview.layer setCornerRadius:4.5];
        [appointmentview.layer setMasksToBounds:YES];
        
        ivPartrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default_user"]];
        [appointmentview addSubview:ivPartrait];
        ivPartrait.layer.cornerRadius = 2.5;
        ivPartrait.layer.masksToBounds = YES;
        
        _archiveButton = [[UIButton alloc] init];
        [self addSubview:_archiveButton];
        [_archiveButton setTitle:@"档案详情 >" forState:UIControlStateNormal];
        [_archiveButton setTitleColor:[UIColor commonLightGrayTextColor] forState:UIControlStateNormal];
        [_archiveButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        
        statusview = [[UIView alloc]init];
        [appointmentview addSubview:statusview];
        [statusview showTopLine];
        
        lbStatus = [[UILabel alloc]init];
        [statusview addSubview:lbStatus];
        [lbStatus setFont:[UIFont systemFontOfSize:12]];
        [lbStatus setTextColor:[UIColor commonGrayTextColor]];
        
        lbPatientName = [[UILabel alloc]init];
        [appointmentview addSubview:lbPatientName];
        [lbPatientName setFont:[UIFont systemFontOfSize:15]];
        [lbPatientName setTextColor:[UIColor commonTextColor]];
        
        lbPatientInfo = [[UILabel alloc]init];
        [appointmentview addSubview:lbPatientInfo];
        [lbPatientInfo setFont:[UIFont systemFontOfSize:13]];
        [lbPatientInfo setTextColor:[UIColor commonTextColor]];
        
        _dealbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [statusview addSubview:_dealbutton];
        [_dealbutton setBackgroundImage:[UIImage rectImage:CGSizeMake(70, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_dealbutton setTitle:@"确认就诊" forState:UIControlStateNormal];
        [_dealbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dealbutton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_dealbutton.layer setCornerRadius:2.5];
        [_dealbutton.layer setMasksToBounds:YES];
        [_dealbutton setHidden:YES];
        [self makeAppointmentContent];
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [appointmentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView);
    }];
    
    [ivPartrait mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appointmentview).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.equalTo(appointmentview).with.offset(13);
    }];
    
    [lbPatientName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivPartrait.mas_right).with.offset(6);
        make.top.equalTo(ivPartrait);
    }];
    
    [_archiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(appointmentview).offset(-8);
        make.top.equalTo(lbPatientName).offset(-5);;
        make.width.mas_greaterThanOrEqualTo(@80);
    }];
    
    [lbPatientInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPatientName.mas_right);
        make.top.equalTo(lbPatientName).with.offset(1);
        make.right.lessThanOrEqualTo(_archiveButton.mas_left);
    }];
    
    [statusview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(appointmentview);
        make.bottom.equalTo(appointmentview);
        make.height.mas_equalTo(39);
    }];
    
    
    [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(statusview).with.offset(12.5);
        make.centerY.equalTo(statusview);
    }];
    
    [_dealbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(statusview).with.offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(70, 30));
        make.centerY.equalTo(statusview);
    }];

    
    [self layoutAppointmentContent];
}

#pragma mark - Initializaton
- (void) makeAppointmentContent
{
    
}

- (void) layoutAppointmentContent
{
    
}

- (void) setAppointmentInfo:(AppointmentInfo*) appoint
{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [ivPartrait sd_setImageWithURL:[NSURL URLWithString:appoint.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
    
    [_dealbutton setHidden:YES];
    [lbStatus setText:[appoint statusString]];
    //[lbApplyType setText:appoint.doWayStr];
    
    [lbPatientName setText:appoint.userName];
    
    if (kStringIsEmpty(appoint.mainIll)) {
        [lbPatientInfo setText:[NSString stringWithFormat:@"(%@|%ld)", appoint.sex, appoint.age]];
    }
    else{
        [lbPatientInfo setText:[NSString stringWithFormat:@"(%@|%ld %@)", appoint.sex, appoint.age,appoint.mainIll]];
    }

    
    [_dealbutton setHidden:YES];
    switch (appoint.status)
    {
        case 1:
        {
            //用户提交约诊申请，判断是否有处理权限
            BOOL dealPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:appoint.status OperateCode:kPrivilegeProcessOperate];
            if (!dealPrivilege)
            {
                return;
            }
            [_dealbutton setTitle:@"处理" forState:UIControlStateNormal];
            [_dealbutton setHidden:NO];
        }
            break;
        case 2:
        {
            StaffInfo* staff = [[UserInfoHelper defaultHelper] currentStaffInfo];
            if (staff.staffId != appoint.staffId)
            {
                //不是指定给我的
                break;
            }
            //顾问已经处理，判断是否有确认就诊权限
            BOOL dealPrivilege = [StaffPrivilegeHelper staffHasPrivilege:kPrivilegeAppointmentMode Status:appoint.status OperateCode:kPrivilegeConfirmOperate];
            if (!dealPrivilege)
            {
                return;
            }
            
            
            [_dealbutton setTitle:@"确认就诊" forState:UIControlStateNormal];
            [_dealbutton setHidden:NO];
        }
            break;
        default:
            break;
    }

}

@end

@interface UserDealedAppointmentTableViewCell ()
{
    UILabel* appointTimeTitleLable;
    UILabel* appointAddrTitleLable;
    UILabel* appointTimeLable;   //就诊时间
    UILabel* appointAddrLable;   //就诊地点
}
@end

@implementation UserDealedAppointmentTableViewCell

#pragma mark - Initializaton
- (void) makeAppointmentContent
{
    appointTimeTitleLable = [[UILabel alloc]init];
    [appointmentview addSubview:appointTimeTitleLable];
    [appointTimeTitleLable setFont:[UIFont font_26]];
    [appointTimeTitleLable setTextColor:[UIColor commonGrayTextColor]];
    [appointTimeTitleLable setText:@"就诊时间:"];
    
    appointAddrTitleLable = [[UILabel alloc]init];
    [appointmentview addSubview:appointAddrTitleLable];
    [appointAddrTitleLable setFont:[UIFont font_26]];
    [appointAddrTitleLable setTextColor:[UIColor commonGrayTextColor]];
    [appointAddrTitleLable setText:@"就诊地点:"];
    
    appointTimeLable = [[UILabel alloc]init];
    [appointmentview addSubview:appointTimeLable];
    [appointTimeLable setFont:[UIFont font_26]];
    [appointTimeLable setTextColor:[UIColor commonGrayTextColor]];
    
    appointAddrLable = [[UILabel alloc]init];
    [appointmentview addSubview:appointAddrLable];
    [appointAddrLable setFont:[UIFont font_26]];
    [appointAddrLable setTextColor:[UIColor commonGrayTextColor]];
}

- (void) layoutAppointmentContent
{
    [appointTimeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPatientName);
        make.top.equalTo(lbPatientName.mas_bottom).with.offset(10);
    }];
    
    [appointTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appointTimeTitleLable.mas_right);
        make.top.equalTo(appointTimeTitleLable);
    }];
    
    [appointAddrTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appointTimeTitleLable);
        make.top.equalTo(appointTimeTitleLable.mas_bottom).with.offset(6);
    }];
    
    [appointAddrLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(appointAddrTitleLable.mas_right);
        make.top.equalTo(appointAddrTitleLable);
    }];
}

- (void) setAppointmentInfo:(AppointmentInfo*) appoint
{
    [super setAppointmentInfo:appoint];
    [appointTimeLable setText:appoint.appointTime];
    [appointAddrLable setText:appoint.appointAddr];
}

@end

@interface UserUnDealedAppointmentTableViewCell ()
{
    UILabel* applyTimeTitleLable;
    UILabel* applyStaffTitleLable;
    UILabel* applyTimeLable;   //申请时间
    UILabel* applyStaffLable;   //申请医生
}
@end

@implementation UserUnDealedAppointmentTableViewCell

#pragma mark - Initializaton
- (void) makeAppointmentContent
{
    applyTimeTitleLable = [[UILabel alloc]init];
    [appointmentview addSubview:applyTimeTitleLable];
    [applyTimeTitleLable setFont:[UIFont font_26]];
    [applyTimeTitleLable setTextColor:[UIColor commonGrayTextColor]];
    [applyTimeTitleLable setText:@"申请时间:"];
    
    applyStaffTitleLable = [[UILabel alloc]init];
    [appointmentview addSubview:applyStaffTitleLable];
    [applyStaffTitleLable setFont:[UIFont font_26]];
    [applyStaffTitleLable setTextColor:[UIColor commonGrayTextColor]];
    [applyStaffTitleLable setText:@"申请医生:"];
    
    applyTimeLable = [[UILabel alloc]init];
    [appointmentview addSubview:applyTimeLable];
    [applyTimeLable setFont:[UIFont font_26]];
    [applyTimeLable setTextColor:[UIColor commonGrayTextColor]];
    
    applyStaffLable = [[UILabel alloc]init];
    [appointmentview addSubview:applyStaffLable];
    [applyStaffLable setFont:[UIFont font_26]];
    [applyStaffLable setTextColor:[UIColor commonGrayTextColor]];
}

- (void) layoutAppointmentContent
{
    [applyTimeTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbPatientName);
        make.top.equalTo(lbPatientName.mas_bottom).with.offset(10);
    }];
    
    [applyTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyTimeTitleLable.mas_right);
        make.top.equalTo(applyTimeTitleLable);
    }];
    
    [applyStaffTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyTimeTitleLable);
        make.top.equalTo(applyTimeTitleLable.mas_bottom).with.offset(6);
    }];
    
    [applyStaffLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(applyStaffTitleLable.mas_right);
        make.top.equalTo(applyStaffTitleLable);
    }];
}

- (void) setAppointmentInfo:(AppointmentInfo*) appoint
{
    [super setAppointmentInfo:appoint];
    [applyTimeLable setText:appoint.createTime];
    [applyStaffLable setText:appoint.staffName];
}

@end

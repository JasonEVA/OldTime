//
//  AppointmentDetailTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentDetailTableViewCell.h"

@interface AppointmentApplyStatusTableViewCell ()
{
    UIView* statusview;
    UIImageView* ivFlag;
    UILabel* lbStatus;
    UILabel* lbApplyType;
}
@end

@implementation AppointmentApplyStatusTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
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
        [lbStatus setFont:[UIFont systemFontOfSize:15]];
        [lbStatus setTextColor:[UIColor mainThemeColor]];
        
        lbApplyType = [[UILabel alloc]init];
        [statusview addSubview:lbApplyType];
        [lbApplyType setFont:[UIFont systemFontOfSize:14]];
        [lbApplyType setTextColor:[UIColor commonGrayTextColor]];
        
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
}

- (void) setAppointmentDetail:(AppointmentDetail*) detail
{
    [lbStatus setText:[detail statusString]];
    [lbApplyType setText:detail.doWayStr];
}
@end

@interface AppointmentDetailTableViewCell ()
{
    UILabel* lbApplyTimeTitle;
    UILabel* lbStaffNameTitle;
    
    
    UILabel* lbAddressTitle;
    UILabel* lbAddress;
    
    UILabel* lbApplyTime;
    UILabel* lbStaffName;
    
    UILabel* lbNoticeTitle;
    UILabel* lbNotice;
    
    UILabel* lbSymptomTitle;
    UILabel* lbSymptom;
}
@end

@implementation AppointmentDetailTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        lbApplyTimeTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbApplyTimeTitle];
        [lbApplyTimeTitle setFont:[UIFont systemFontOfSize:14]];
        [lbApplyTimeTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbApplyTimeTitle setText:@"就诊时间:"];
        
        lbApplyTime = [[UILabel alloc]init];
        [self.contentView addSubview:lbApplyTime];
        [lbApplyTime setFont:[UIFont systemFontOfSize:14]];
        [lbApplyTime setTextColor:[UIColor commonTextColor]];
        
        lbAddressTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbAddressTitle];
        [lbAddressTitle setFont:[UIFont systemFontOfSize:14]];
        [lbAddressTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbAddressTitle setText:@"就诊地点:"];
        
//        NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];
//        if ([staffRole isEqualToString:@"adviser"])
//        {
//            [lbApplyTimeTitle setText:@"申请时间:"];
//            [lbAddressTitle setText:@"申请人:"];
//        }
        
        
        lbAddress = [[UILabel alloc]init];
        [self.contentView addSubview:lbAddress];
        [lbAddress setFont:[UIFont systemFontOfSize:14]];
        [lbAddress setTextColor:[UIColor commonTextColor]];
        
        lbStaffNameTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbStaffNameTitle];
        [lbStaffNameTitle setFont:[UIFont systemFontOfSize:14]];
        [lbStaffNameTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbStaffNameTitle setText:@"医生:"];
//        if ([staffRole isEqualToString:@"adviser"])
//        {
//            [lbStaffNameTitle setText:@"申请医生:"];
//        }
        
        lbStaffName = [[UILabel alloc]init];
        [self.contentView addSubview:lbStaffName];
        [lbStaffName setFont:[UIFont systemFontOfSize:14]];
        [lbStaffName setTextColor:[UIColor commonTextColor]];
        
        lbNoticeTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbNoticeTitle];
        [lbNoticeTitle setFont:[UIFont systemFontOfSize:14]];
        [lbNoticeTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbNoticeTitle setText:@"附加信息:"];
        
        lbNotice = [[UILabel alloc]init];
        [self.contentView addSubview:lbNotice];
        [lbNotice setFont:[UIFont systemFontOfSize:14]];
        [lbNotice setTextColor:[UIColor commonTextColor]];
        
        lbSymptomTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbSymptomTitle];
        [lbSymptomTitle setFont:[UIFont systemFontOfSize:14]];
        [lbSymptomTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbSymptomTitle setText:@"症状描述:"];
        
        lbSymptom = [[UILabel alloc]init];
        [self.contentView addSubview:lbSymptom];
        [lbSymptom setFont:[UIFont systemFontOfSize:14]];
        [lbSymptom setTextColor:[UIColor commonTextColor]];
        [lbSymptom setNumberOfLines:0];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_cancelButton];
        [_cancelButton setHidden:YES];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        _cancelButton.layer.borderColor = [UIColor mainThemeColor].CGColor;
        _cancelButton.layer.borderWidth = 0.5;
        _cancelButton.layer.cornerRadius = 2.5;
        _cancelButton.layer.masksToBounds = YES;
        
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbApplyTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(self.contentView).with.offset(11);
    }];
    
    [lbApplyTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbApplyTimeTitle.mas_right);
        make.top.equalTo(lbApplyTimeTitle);
    }];
    
    [lbAddressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbApplyTimeTitle.mas_bottom).with.offset(11);
    }];
    
    [lbAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbAddressTitle.mas_right);
        make.top.equalTo(lbAddressTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbStaffNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbAddressTitle.mas_bottom).with.offset(11);
    }];
    
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbStaffNameTitle.mas_right);
        make.top.equalTo(lbStaffNameTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbNoticeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbStaffNameTitle.mas_bottom).with.offset(11);
    }];
    
    [lbNotice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbNoticeTitle.mas_right);
        make.top.equalTo(lbNoticeTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];

    
    [lbSymptomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbNoticeTitle.mas_bottom).with.offset(11);
    }];
    
    [lbSymptom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(12.5);
        make.top.equalTo(lbSymptomTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(lbApplyTime);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];

}

- (void) setAppointmentDetail:(AppointmentDetail*) detail
{
    [lbApplyTime setText:detail.appointTime];
    [lbAddress setText:detail.appointAddr];
    
    //NSString* staffRole = [[UserInfoHelper defaultHelper] staffRole];

    switch (detail.status)
    {
        case 2:
        case 4:
        
            break;
            
        default:
        {
            [lbApplyTimeTitle setText:@"申请时间:"];
            [lbAddressTitle setText:@"申请人:"];
            [lbStaffNameTitle setText:@"申请医生:"];
            
            [lbApplyTime setText:detail.createTime];
            [lbAddress setText:detail.userName];
        }
            break;
    }
  
    
    NSString* staffStr = detail.staffName;
    NSString* expendStr = [detail staffExpendString];
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
    [lbStaffName setText:staffStr];
    [lbNotice setText:detail.noticeCon];
    
    NSString* symptomDesc = [NSString stringWithFormat:@"                %@", detail.symptomDesc];
    [lbSymptom setText:symptomDesc];
    
    
}

@end

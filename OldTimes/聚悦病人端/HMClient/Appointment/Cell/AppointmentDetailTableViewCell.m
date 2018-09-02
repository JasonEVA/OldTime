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
        [lbStatus setFont:[UIFont font_30]];
        [lbStatus setTextColor:[UIColor mainThemeColor]];
        
        lbApplyType = [[UILabel alloc]init];
        [statusview addSubview:lbApplyType];
        [lbApplyType setFont:[UIFont font_28]];
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
    
}
@end

@implementation AppointmentDetailTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createSubviews];
        [self subviewLayout];
    }
    return self;
}

- (void) createSubviews
{
    lbApplyTimeTitle = [[UILabel alloc]init];
    [self.contentView addSubview:lbApplyTimeTitle];
    [lbApplyTimeTitle setFont:[UIFont font_28]];
    [lbApplyTimeTitle setTextColor:[UIColor commonGrayTextColor]];
    [lbApplyTimeTitle setText:@"申请时间:"];
    
    lbApplyTime = [[UILabel alloc]init];
    [self.contentView addSubview:lbApplyTime];
    [lbApplyTime setFont:[UIFont font_28]];
    [lbApplyTime setTextColor:[UIColor commonTextColor]];
    
    lbStaffNameTitle = [[UILabel alloc]init];
    [self.contentView addSubview:lbStaffNameTitle];
    [lbStaffNameTitle setFont:[UIFont font_28]];
    [lbStaffNameTitle setTextColor:[UIColor commonGrayTextColor]];
    [lbStaffNameTitle setText:@"医生:"];
    
    lbStaffName = [[UILabel alloc]init];
    [self.contentView addSubview:lbStaffName];
    [lbStaffName setFont:[UIFont font_28]];
    [lbStaffName setTextColor:[UIColor commonTextColor]];
    [lbStaffName setNumberOfLines:0];

    lbNoteTitle = [[UILabel alloc]init];
    [self.contentView addSubview:lbNoteTitle];
    [lbNoteTitle setFont:[UIFont font_28]];
    [lbNoteTitle setTextColor:[UIColor commonGrayTextColor]];
    [lbNoteTitle setText:@"附加消息:"];
    
    lbNote = [[UILabel alloc]init];
    [self.contentView addSubview:lbNote];
    [lbNote setFont:[UIFont font_28]];
    [lbNote setTextColor:[UIColor commonTextColor]];
    
    lbSymptomTitle = [[UILabel alloc]init];
    [self.contentView addSubview:lbSymptomTitle];
    [lbSymptomTitle setFont:[UIFont font_28]];
    [lbSymptomTitle setTextColor:[UIColor commonGrayTextColor]];
    [lbSymptomTitle setText:@"症状描述:"];
    
    lbSymptom = [[UILabel alloc]init];
    [self.contentView addSubview:lbSymptom];
    [lbSymptom setFont:[UIFont font_28]];
    [lbSymptom setTextColor:[UIColor commonTextColor]];
    [lbSymptom setNumberOfLines:0];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_cancelButton];
    //[_cancelButton setHidden:YES];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
    [_cancelButton.titleLabel setFont:[UIFont font_24]];
    _cancelButton.layer.borderColor = [UIColor mainThemeColor].CGColor;
    _cancelButton.layer.borderWidth = 0.5;
    _cancelButton.layer.cornerRadius = 2.5;
    _cancelButton.layer.masksToBounds = YES;
    

}

- (void) subviewLayout
{
    [lbApplyTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(self.contentView).with.offset(11);
    }];
    
    [lbApplyTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbApplyTimeTitle.mas_right).offset(5);
        make.top.equalTo(lbApplyTimeTitle);
    }];
    
    [lbStaffNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbApplyTimeTitle.mas_bottom).with.offset(11);
    }];
    
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbStaffNameTitle.mas_right).offset(5);
        make.top.equalTo(lbStaffNameTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbNoteTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbStaffName.mas_bottom).with.offset(11);
    }];
    
    [lbNote mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbNoteTitle.mas_right).offset(5);
        make.top.equalTo(lbNoteTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbSymptomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbNoteTitle.mas_bottom).with.offset(11);
    }];
    
    [lbSymptom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbSymptomTitle.mas_right).offset(5);
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
    [lbApplyTime setText:detail.createTime];
    
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
    [lbNote setText:detail.noticeCon];
    //不知道这串空格干啥用的，先注释了 - by Jason
//    NSString* symptomDesc = [NSString stringWithFormat:@"                %@", detail.symptomDesc];
    [lbSymptom setText:detail.symptomDesc];
    
    switch (detail.status)
    {
        case 1:
        case 2:
        {
            [_cancelButton setHidden:NO];
        }
            break;
            
        default:
        {
            [_cancelButton setHidden:YES];
        }
            break;
    }
}

@end

@interface AppointmentFinishedDetailTableViewCell ()
{
    UILabel* lbAppointTimeTitle;
    UILabel* lbAddressTitle;
    
    UILabel* lbAppointTime;
    UILabel* lbAddress;
}
@end

@implementation AppointmentFinishedDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void) createSubviews
{
    [super createSubviews];
    lbAppointTimeTitle = [[UILabel alloc]init];
    [self.contentView addSubview:lbAppointTimeTitle];
    [lbAppointTimeTitle setFont:[UIFont font_28]];
    [lbAppointTimeTitle setTextColor:[UIColor commonGrayTextColor]];
    [lbAppointTimeTitle setText:@"就诊时间:"];
    
    lbAddressTitle = [[UILabel alloc]init];
    [self.contentView addSubview:lbAddressTitle];
    [lbAddressTitle setFont:[UIFont font_28]];
    [lbAddressTitle setTextColor:[UIColor commonGrayTextColor]];
    [lbAddressTitle setText:@"就诊地点:"];
    
    lbAppointTime = [[UILabel alloc]init];
    [self.contentView addSubview:lbAppointTime];
    [lbAppointTime setFont:[UIFont font_28]];
    [lbAppointTime setTextColor:[UIColor commonTextColor]];
    
    lbAddress = [[UILabel alloc]init];
    [self.contentView addSubview:lbAddress];
    [lbAddress setFont:[UIFont font_28]];
    [lbAddress setTextColor:[UIColor commonTextColor]];
}

- (void) subviewLayout
{
    [lbApplyTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(self.contentView).with.offset(11);
    }];
    
    [lbApplyTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbApplyTimeTitle.mas_right).offset(5);
        make.top.equalTo(lbApplyTimeTitle);
    }];
    
    [lbStaffNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbApplyTimeTitle.mas_bottom).with.offset(11);
    }];
    
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbStaffNameTitle.mas_right).offset(5);
        make.top.equalTo(lbStaffNameTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbAppointTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbStaffName.mas_bottom).with.offset(11);
    }];
    
    [lbAppointTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbAppointTimeTitle.mas_right).offset(5);
        make.top.equalTo(lbAppointTimeTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbAddressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbAppointTimeTitle.mas_bottom).with.offset(11);
    }];
    
    [lbAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbAddressTitle.mas_right).offset(5);
        make.top.equalTo(lbAddressTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbSymptomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(lbAddressTitle.mas_bottom).with.offset(11);
    }];
    
    [lbSymptom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbSymptomTitle.mas_right).offset(5);
        make.top.equalTo(lbSymptomTitle);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(lbApplyTime);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];
    
}

- (void) setAppointmentDetail:(AppointmentDetail*) detail
{
    [super setAppointmentDetail:detail];
    [lbAppointTime setText:detail.appointTime];
    [lbAddress setText:detail.appointAddr];
}

@end


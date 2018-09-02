//
//  AppointmentSelectStaffTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/11/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentSelectStaffTableViewCell.h"

@interface AppointmentSelectStaffTableViewCell ()
{
    UIImageView* ivStaffHeader;
    UILabel* lbStaffName;
    UILabel* lbStaffTypeName;
    UILabel* lbRemainNum;
    UILabel* lbEndTime;
    UIImageView* ivSelect;
}
@end

@implementation AppointmentSelectStaffTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        ivStaffHeader = [[UIImageView alloc] init];
        [self.contentView addSubview:ivStaffHeader];
        [ivStaffHeader.layer setCornerRadius:40/2];
        [ivStaffHeader.layer setMasksToBounds:YES];
        
        lbStaffName = [[UILabel alloc] init];
        [self.contentView addSubview:lbStaffName];
        [lbStaffName setFont:[UIFont font_26]];
        [lbStaffName setTextColor:[UIColor commonTextColor]];
        
        lbStaffTypeName = [[UILabel alloc] init];
        [self.contentView addSubview:lbStaffTypeName];
        [lbStaffTypeName setFont:[UIFont font_24]];
        [lbStaffTypeName setTextColor:[UIColor commonGrayTextColor]];
        
        lbEndTime = [[UILabel alloc] init];
        [self.contentView addSubview:lbEndTime];
        [lbEndTime setFont:[UIFont font_24]];
        [lbEndTime setTextColor:[UIColor commonGrayTextColor]];
        
        lbRemainNum = [[UILabel alloc] init];
        [self.contentView addSubview:lbRemainNum];
        [lbRemainNum setFont:[UIFont font_26]];
        [lbRemainNum setTextColor:[UIColor commonRedColor]];
        
        ivSelect = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"select_m"]];
        [self addSubview:ivSelect];
//        [ivSelect setHidden:YES];
        
        [self subviewsLayout];
        
    }
    return self;
}

- (void)subviewsLayout
{
    [ivSelect mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).with.offset(-12.5);
//        make.top.equalTo(lbRemainNum.mas_bottom).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(12.5);
    }];
    
    [ivStaffHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivSelect.mas_right).offset(5);
        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ivStaffHeader);
        make.left.equalTo(ivStaffHeader.mas_right).with.offset(10);
    }];
    
    [lbStaffTypeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lbStaffName.mas_bottom);
        make.left.equalTo(lbStaffName.mas_right).with.offset(10);
    }];
    
    [lbEndTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ivStaffHeader.mas_bottom);
        make.left.equalTo(lbStaffName);
    }];
    
    [lbRemainNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ivStaffHeader);
        make.right.equalTo(self.contentView).with.offset(-12.5);
    }];
    
    
}

- (void) setStaffInfo:(AppointStaffModel*) staff
{
    [lbStaffName setText:staff.staffName];
    [lbStaffTypeName setText:staff.staffTypeName];
    [lbRemainNum setText:[NSString stringWithFormat:@"剩%ld次",staff.remainNum]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:staff.endTime];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *timeStr = [formatter stringFromDate:date];
    [lbEndTime setText:[NSString stringWithFormat:@"预约有效期截止至：%@",timeStr]];
    
    if (staff.imgUrl)
    {
        [ivStaffHeader sd_setImageWithURL:[NSURL URLWithString:staff.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_default_staff"]];
    }
    
    [ivSelect setHidden:(staff.remainNum == 0)];
    
}

- (void) setIsSelected:(BOOL) selected
{
   
    if (selected) {
//        [ivSelect setHidden:NO];
        [ivSelect setImage:[UIImage imageNamed:@"select_s"]];
    }
    else{
//        [ivSelect setHidden:YES];
        [ivSelect setImage:[UIImage imageNamed:@"select_m"]];
    }
    //[ivSelect setHidden:!selected];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

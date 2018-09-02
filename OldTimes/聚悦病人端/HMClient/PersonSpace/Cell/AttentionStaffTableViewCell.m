//
//  AttentionStaffTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AttentionStaffTableViewCell.h"

@interface AttentionStaffTableViewCell ()
{
    UIView* staffview;
    UIView* bottomview;
    
    UIImageView* ivStaff;
    UILabel* lbStaffName;
    UILabel* lbStaffType;
    UILabel* lbGoodat;
}
@end

@implementation AttentionStaffTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        bottomview = [[UIView alloc]init];
        [self.contentView addSubview:bottomview];
        [bottomview setBackgroundColor:[UIColor commonBackgroundColor]];
        [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@5);
        }];
        
        staffview = [[UIView alloc]init];
        [self.contentView addSubview:staffview];
        [staffview setBackgroundColor:[UIColor whiteColor]];
        [staffview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(bottomview.mas_top);
        }];
        
        ivStaff = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default_staff"]];
        [staffview addSubview:ivStaff];
        ivStaff.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        ivStaff.layer.borderWidth = 0.5;
        ivStaff.layer.cornerRadius = 27;
        ivStaff.layer.masksToBounds = YES;
        
        [ivStaff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(staffview).with.offset(12.5);
            make.centerY.equalTo(staffview);
            make.size.mas_equalTo(CGSizeMake(54, 54));
        }];
        
        lbStaffName = [[UILabel alloc]init];
        [staffview addSubview:lbStaffName];
        [lbStaffName setTextColor:[UIColor commonTextColor]];
        [lbStaffName setFont:[UIFont font_30]];
        [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivStaff.mas_right).with.offset(10);
            make.top.equalTo(ivStaff);
        }];
        
        lbStaffType = [[UILabel alloc]init];
        [staffview addSubview:lbStaffType];
        [lbStaffType setTextColor:[UIColor commonTextColor]];
        [lbStaffType setFont:[UIFont font_22]];
        [lbStaffType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbStaffName.mas_right).with.offset(2);
            make.bottom.equalTo(lbStaffName).with.offset(-1);
        }];
        
        lbGoodat = [[UILabel alloc]init];
        [staffview addSubview:lbGoodat];
        [lbGoodat setTextColor:[UIColor commonGrayTextColor]];
        [lbGoodat setFont:[UIFont font_26]];
        [lbGoodat setNumberOfLines:2];
        [lbGoodat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivStaff.mas_right).with.offset(10);
            make.top.equalTo(lbStaffName.mas_bottom).with.offset(5);
        }];
    }
    return self;
}

- (void) setStaffInfo:(StaffInfo*) staff
{
    [ivStaff setImage:[UIImage imageNamed:@"icon_default_staff"]];
    if (staff.imgUrl && 0 < staff.imgUrl.length)
    {
        [ivStaff sd_setImageWithURL:[NSURL URLWithString:staff.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_default_staff"]];
    }
    [lbStaffName setText:staff.staffName];
    if (staff.staffTypeName)
    {
        [lbStaffType setText:[NSString stringWithFormat:@"(%@)", staff.staffTypeName]];
    }
    
    [lbGoodat setText:[NSString stringWithFormat:@"擅长:%@", staff.gootAt]];
}

@end

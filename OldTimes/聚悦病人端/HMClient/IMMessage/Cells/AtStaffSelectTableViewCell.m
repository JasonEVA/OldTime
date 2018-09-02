//
//  AtStaffSelectTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/6/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AtStaffSelectTableViewCell.h"

@interface AtStaffSelectTableViewCell ()
{
    UIImageView* ivStaff;
    UILabel* lbStaffName;
}
@end

@implementation AtStaffSelectTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivStaff = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default_staff"]];
        [self.contentView addSubview:ivStaff];
        ivStaff.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        ivStaff.layer.borderWidth = 0.5;
        ivStaff.layer.cornerRadius = 17;
        ivStaff.layer.masksToBounds = YES;
        
        [ivStaff mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.centerY.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(34, 34));
        }];
        
        lbStaffName = [[UILabel alloc]init];
        [self.contentView addSubview:lbStaffName];
        [lbStaffName setFont:[UIFont font_30]];
        [lbStaffName setTextColor:[UIColor commonTextColor]];
        [lbStaffName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivStaff.mas_right).with.offset(10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void) setStaff:(StaffInfo*) staff
{
    [ivStaff setImage:[UIImage imageNamed:@"ivStaff"]];
    if (staff.imgUrl)
    {
        [ivStaff sd_setImageWithURL:[NSURL URLWithString:staff.imgUrl] placeholderImage:[UIImage imageNamed:@"ivStaff"]];
    }
    [lbStaffName setText:staff.staffName];
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

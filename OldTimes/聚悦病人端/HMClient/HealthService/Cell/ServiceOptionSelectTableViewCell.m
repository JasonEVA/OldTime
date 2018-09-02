//
//  ServiceOptionSelectTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceOptionSelectTableViewCell.h"

@interface ServiceOptionSelectTableViewCell ()
{
    UILabel* lbName;
    UILabel* lbBillWay;
    UIImageView* ivSelected;
}
@end

@implementation ServiceOptionSelectTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        lbName = [[UILabel alloc]init];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont font_26]];
        [lbName setTextColor:[UIColor commonGrayTextColor]];
        [self.contentView addSubview:lbName];
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-54);
        }];
        
        lbBillWay = [[UILabel alloc]init];
        [lbBillWay setBackgroundColor:[UIColor clearColor]];
        [lbBillWay setFont:[UIFont font_26]];
        [lbBillWay setTextColor:[UIColor commonTextColor]];
        [self.contentView addSubview:lbBillWay];
        [lbBillWay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-51.5);
        }];

        //icon_checkbox_Selections
        ivSelected = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_checkbox_Selections"]];
        [self.contentView addSubview:ivSelected];
        [ivSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).with.offset(-12.5);
        }];
    }
    return self;
}

- (void) setOption:(ServiceDetailOption*) option
{
    [lbName setText:option.productName];
    [lbBillWay setText:[NSString stringWithFormat:@"%ld%@", option.billWayNum, option.billWayName]];
}

- (void) setOptionSelected:(BOOL) isSelected
{
    [ivSelected setHidden:!isSelected];
}

@end

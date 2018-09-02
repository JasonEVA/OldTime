//
//  PersonStartManageTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonStartManageTableViewCell.h"

@interface PersonStartManageTableViewCell ()
{
    UIImageView* ivIcon;
    UILabel* lbName;
}


@end

@implementation PersonStartManageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:ivIcon];
        [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.centerY.equalTo(self.contentView);
//            make.width.height.equalTo(@21);
        }];
        lbName = [[UILabel alloc]init];
        [self.contentView addSubview:lbName];
        [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivIcon.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
        }];
        
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setFont:[UIFont systemFontOfSize:16]];
        [lbName setTextColor:[UIColor commonTextColor]];
        
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        [self subviewLayout];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setName:(NSString*) name
            Icon:(UIImage*) icon
{
    [ivIcon setImage:icon];
    [lbName setText:name];
}

- (void) subviewLayout
{

}

@end

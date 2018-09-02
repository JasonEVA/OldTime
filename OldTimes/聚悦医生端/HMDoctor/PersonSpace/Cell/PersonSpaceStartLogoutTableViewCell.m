//
//  PersonSpaceStartLogoutTableViewCell.m
//  HMDoctor
//
//  Created by yinquan on 16/4/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceStartLogoutTableViewCell.h"

@implementation PersonSpaceStartLogoutTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.textLabel setText:@"退出登录"];
        [self.textLabel setFont:[UIFont systemFontOfSize:15]];
        [self.textLabel setTextColor:[UIColor commonTextColor]];
    }
    return self;
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

@implementation PersonSpaceStartSettingTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.textLabel setText:@"设置"];
        [self.textLabel setFont:[UIFont systemFontOfSize:15]];
        [self.textLabel setTextColor:[UIColor commonTextColor]];
    }
    return self;
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

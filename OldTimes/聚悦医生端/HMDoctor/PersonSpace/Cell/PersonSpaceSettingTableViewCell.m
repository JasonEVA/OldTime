//
//  PersonSpaceSettingTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PersonSpaceSettingTableViewCell.h"

@interface PersonSpaceSettingTableViewCell ()
{
    UILabel* lbTitle;
}
@end

@implementation PersonSpaceSettingTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        lbTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbTitle];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:16]];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
        make.height.mas_equalTo(@21);
        make.centerY.equalTo(self.contentView);
    }];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setTitle:(NSString*) title
{
    [lbTitle setText:title];
}

@end

@interface PersonSpaceSettingNotificationTableViewCell ()
{
    UIImageView* ivIcon;
    UILabel* lbTitle;
   // UIImageView* ivRihgtArrow;
    UISwitch* swNotification;
}
@end

@implementation PersonSpaceSettingNotificationTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        
        /*ivIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:ivIcon];
        [ivIcon setImage:[UIImage imageNamed:@"ic_setting_notification"]];*/
        
        lbTitle = [[UILabel alloc]init];
        [self.contentView addSubview:lbTitle];
        [lbTitle setBackgroundColor:[UIColor clearColor]];
        [lbTitle setFont:[UIFont systemFontOfSize:16]];
        [lbTitle setTextColor:[UIColor commonTextColor]];
        [lbTitle setText:@"新消息提示"];
        
        swNotification = [[UISwitch alloc]init];
        [self.contentView addSubview:swNotification];
        [swNotification setEnabled:NO];
        
        [swNotification setOn:[UIApplication sharedApplication].isRegisteredForRemoteNotifications];
        [self subviewsLayout];
    }
    return self;
}

- (void) subviewsLayout
{
    /*[ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(23, 23));
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(15);
    }];*/
    
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        //make.right.equalTo(swNotification.mas_left).with.offset(-5);
        make.height.mas_equalTo(@21);
        make.centerY.equalTo(self.contentView);
    }];
    
    [swNotification mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(6, 10));
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-12);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end

@interface PersonSpaceSettingLogoutTableViewCell ()
{
    UILabel* lbExit;
}
@end

@implementation PersonSpaceSettingLogoutTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        lbExit = [[UILabel alloc] init];
        [lbExit setBackgroundColor:[UIColor mainThemeColor]];
        [lbExit setFont:[UIFont systemFontOfSize:16]];
        [lbExit setText:@"退出登录"];
        [lbExit setTextColor:[UIColor whiteColor]];
        [lbExit setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lbExit];
        
        lbExit.layer.borderColor = [[UIColor mainThemeColor] CGColor];
        lbExit.layer.borderWidth = 0.5;
        lbExit.layer.cornerRadius = 2.5;
        lbExit.layer.masksToBounds = YES;
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    [lbExit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.top.and.bottom.equalTo(self.contentView);
        //make.height.mas_equalTo(47);
    }];
}

@end


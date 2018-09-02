//
//  PersonSettingTableViewCell.m
//  HMClient
//
//  Created by lkl on 16/4/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonSettingTableViewCell.h"

@interface PersonSettingTableViewCell ()
{
    //UIImageView *ivIcon;
    UILabel *lbtextContent;
    
    UIImageView *iconArrows;
    UIView* bottomline;
}

@end

@implementation PersonSettingTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        
        lbtextContent = [[UILabel alloc] init];
        [lbtextContent setFont:[UIFont font_26]];
        [self.contentView addSubview:lbtextContent];
        
        iconArrows = [[UIImageView alloc] init];
        [iconArrows setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self.contentView addSubview:iconArrows];
        
        bottomline = [[UIView alloc]init];
        [self.contentView addSubview:bottomline];
        [bottomline setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [self subviewsLayout];
    }
    return self;
}

- (void)subviewsLayout
{
    [lbtextContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    [iconArrows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).with.offset(-12.5);
        make.width.mas_equalTo(@7);
        make.height.mas_equalTo(@13);
        
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@0.5);
    }];
}



- (void) settextContent:(NSString *)aContent
{
    [lbtextContent setText:aContent];
}

@end



#pragma mark ------------PersonMessageTableViewCell

@interface PersonMessageTableViewCell ()
{
    UILabel *lbtextContent;
    UISwitch *switchButton;
    UIView* bottomline;
}
@end

@implementation PersonMessageTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

        
        lbtextContent = [[UILabel alloc] init];
        [lbtextContent setFont:[UIFont font_26]];
        [self.contentView addSubview:lbtextContent];

        switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame)-60, 8, 0, 0)];
        [switchButton setOn:YES animated:YES];
        [switchButton addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:switchButton];
        [switchButton setEnabled:NO];
        
        [switchButton setOn:[UIApplication sharedApplication].isRegisteredForRemoteNotifications];
        
        bottomline = [[UIView alloc]init];
        [self.contentView addSubview:bottomline];
        [bottomline setBackgroundColor:[UIColor commonControlBorderColor]];
        
        [self subviewsLayout];
    }
    return self;
}

-(void)switchIsChanged:(UISwitch*)sender
{
    
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"设置－新消息提示"];
    if ([sender isOn])
    {
        NSLog(@"switchON");
    }else {
        NSLog(@"switchOFF");
    }
}

- (void)subviewsLayout
{
    [lbtextContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.centerY.equalTo(self.contentView);
        
    }];

    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@0.5);
    }];
}

- (void) settextContent:(NSString *)aContent
{
    [lbtextContent setText:aContent];
}

@end


#pragma mark ------------PersonExitTableViewCell

@interface PersonExitTableViewCell ()
{
    UILabel *lbExit;
}

@end

@implementation PersonExitTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self.contentView setBackgroundColor:[UIColor commonBackgroundColor]];
        lbExit = [[UILabel alloc] init];
        [lbExit setBackgroundColor:[UIColor whiteColor]];
        [lbExit setFont:[UIFont font_30]];
        [lbExit setText:@"退出登录"];
        [lbExit setTextColor:[UIColor mainThemeColor]];
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



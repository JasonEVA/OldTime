//
//  DoctorTeamTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DoctorTeamTableViewCell.h"

@interface DoctorTeamTableViewCell ()
{
    UIImageView* ivTeamStaff;
    UILabel* lbTeamName;
    UILabel* lbTeamStaffTitle;
    UILabel* lbTeamStaff;
    UILabel* lbStaffType;
    
    UILabel* lbOrgTitle;
    UILabel* lbOrgName;
    
    UILabel* lbDesc;
    
    UIView* bottomline;
}
@end

@implementation DoctorTeamTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createControls];
        [self subviewLayout];
    }
    return self;
}

- (void) createControls
{
    ivTeamStaff = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_default_staff"]];
    [self.contentView addSubview:ivTeamStaff];
    ivTeamStaff.layer.borderWidth = 0.5;
    ivTeamStaff.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
    ivTeamStaff.layer.cornerRadius = 25;
    ivTeamStaff.layer.masksToBounds = YES;
    
    lbTeamName = [[UILabel alloc]init];
    [self.contentView addSubview:lbTeamName];
    [lbTeamName setTextColor:[UIColor commonTextColor]];
    [lbTeamName setFont:[UIFont font_30]];
    
    lbTeamStaffTitle = [[UILabel alloc]init];
    [self.contentView addSubview:lbTeamStaffTitle];
    [lbTeamStaffTitle setTextColor:[UIColor commonTextColor]];
    [lbTeamStaffTitle setFont:[UIFont font_24]];
    [lbTeamStaffTitle setText:@"团队长:"];
    
    lbTeamStaff = [[UILabel alloc]init];
    [self.contentView addSubview:lbTeamStaff];
    [lbTeamStaff setTextColor:[UIColor commonTextColor]];
    [lbTeamStaff setFont:[UIFont font_24]];
    
    lbStaffType = [[UILabel alloc]init];
    [self.contentView addSubview:lbStaffType];
    [lbStaffType setTextColor:[UIColor commonGrayTextColor]];
    [lbStaffType setFont:[UIFont font_24]];
    
    lbOrgTitle = [[UILabel alloc]init];
    [self.contentView addSubview:lbOrgTitle];
    [lbOrgTitle setTextColor:[UIColor commonTextColor]];
    [lbOrgTitle setFont:[UIFont font_24]];
    [lbOrgTitle setText:@"医院:"];
    
    lbOrgName = [[UILabel alloc]init];
    [self.contentView addSubview:lbOrgName];
    [lbOrgName setTextColor:[UIColor commonTextColor]];
    [lbOrgName setFont:[UIFont font_24]];
    
    lbDesc = [[UILabel alloc]init];
    [self.contentView addSubview:lbDesc];
    [lbDesc setTextColor:[UIColor commonGrayTextColor]];
    [lbDesc setFont:[UIFont font_24]];
    [lbDesc setNumberOfLines:2];
    
    bottomline = [[UIView alloc]init];
    [bottomline setBackgroundColor:[UIColor commonBackgroundColor]];
    [self.contentView addSubview:bottomline];
}

- (void) subviewLayout
{
    [ivTeamStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(self.contentView).with.offset(14);
    }];
    
    [lbTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ivTeamStaff.mas_right).with.offset(11);
        make.top.equalTo(ivTeamStaff);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
    }];
    
    [lbTeamStaffTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTeamName);
        make.top.equalTo(lbTeamName.mas_bottom).with.offset(3);
    }];
    
    [lbTeamStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTeamStaffTitle.mas_right);
        make.top.equalTo(lbTeamStaffTitle);
    }];
    
    [lbStaffType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTeamStaff.mas_right);
        make.top.equalTo(lbTeamStaff);
    }];
    
    [lbOrgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTeamName);
        make.top.equalTo(lbTeamStaffTitle.mas_bottom).with.offset(5);
    }];
    
    [lbOrgName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbOrgTitle.mas_right);
        make.top.equalTo(lbOrgTitle);
    }];
    
    [lbDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbTeamName);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        make.top.equalTo(lbOrgTitle.mas_bottom).with.offset(5);
        make.height.mas_lessThanOrEqualTo(@30);
    }];
    
    [bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@5);
        
    }];
}

- (void) setTeamInfo:(TeamInfo*) team
{
    if (!team)
    {
        return;
    }
    
    [lbTeamName setText:team.teamName];
    [lbTeamStaff setText:team.teamStaffName];
   
    NSString* staffType = @"";
    if (team.staffTypeName && 0 < team.staffTypeName.length) {
        staffType = [staffType stringByAppendingFormat:@"(%@)", team.staffTypeName];
    }
    
    if (team.depName && 0 < team.depName.length) {
        staffType = [staffType stringByAppendingString:team.depName];
    }
    
    [lbStaffType setText:staffType];
    [lbOrgName setText:team.orgName];
    if (team.teamDesc)
    {
        [lbDesc setText:[NSString stringWithFormat:@"描述:%@", team.teamDesc]];
    }
    else
    {
        [lbDesc setText:@""];
    }
    

    if (team.imgUrl)
    {
        [ivTeamStaff sd_setImageWithURL:[NSURL URLWithString:team.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_default_staff"]];
    }
}

@end

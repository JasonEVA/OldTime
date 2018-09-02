//
//  PersonInfoBodySignTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/4/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonInfoBodySignTableViewCell.h"
#import "UserOftenIllInfo.h"

@interface PersonInfoBodySignTableViewCell ()
{
    UILabel* lbName;
    UILabel* lbValue;
    UIImageView* ivArrow ;
}
@end

@implementation PersonInfoBodySignTableViewCell

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
    if (self) {
        
        lbName = [[UILabel alloc]init];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont font_32]];
        [self.contentView addSubview:lbName];
        
        lbValue = [[UILabel alloc]init];
        [lbValue setBackgroundColor:[UIColor clearColor]];
        [lbValue setTextColor:[UIColor commonTextColor]];
        [lbValue setFont:[UIFont font_32]];
        
        [self.contentView addSubview:lbValue];
        
        ivArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self.contentView addSubview:ivArrow];
        
        [self subViewLayout];
    }
    return self;
}

- (void)subViewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.contentView);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbName.mas_right).with.offset(14);
        make.centerY.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12);
    }];
    
    [ivArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-12.5);
        make.size.mas_equalTo(CGSizeMake(7, 14));
    }];
}

- (void) setTitle:(NSString*) title
{
    [lbName setText:title];
}

- (void) setSignValue:(NSString*) sign
{
    [lbValue setText:sign];
}

@end

@interface PersonInfoDiseaseTableViewCell ()
{
    UILabel* lbName;
    UILabel* lbValue;
}
@end

@implementation PersonInfoDiseaseTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        lbName = [[UILabel alloc]init];
        [lbName setBackgroundColor:[UIColor clearColor]];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont font_32]];
        [self.contentView addSubview:lbName];
        [lbName setText:@"疾病"];
        
        lbValue = [[UILabel alloc]init];
        [lbValue setBackgroundColor:[UIColor clearColor]];
        [lbValue setTextColor:[UIColor colorWithHexString:@"6C6C6C"]];
        [lbValue setFont:[UIFont font_32]];
        [lbValue setText:@"暂无"];
        [self.contentView addSubview:lbValue];
        
        [self subViewLayout];
    }
    return self;
}

- (void)subViewLayout
{
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.equalTo(self.contentView);
        
        make.height.mas_equalTo(20);
    }];
    
    [lbValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbName.mas_right).with.offset(14);
        make.centerY.equalTo(self.contentView);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12);
        make.height.equalTo(lbName.mas_height);
    }];
}

- (void) setUserInfo:(UserInfo*) userInfo
{
    if (!userInfo)
    {
        return;
    }
    if (!userInfo.userIlls || 0 == userInfo.userIlls)
    {
        [lbValue setText:@"暂无"];
        return;
    }
    
    NSString* illsStr = @"";
    for (UserOftenIllInfo* userIll in userInfo.userIlls)
    {
        if (0 < illsStr.length) {
            illsStr = [illsStr stringByAppendingString:@"、"];
        }
        illsStr = [illsStr stringByAppendingString:userIll.illName];
    }
    
    [lbValue setText:illsStr];
}
@end

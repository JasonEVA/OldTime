//
//  HealthPlanMessionTableViewCell.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthPlanMessionTableViewCell.h"

@interface HealthPlanMessionStatusView : UIView
{
    UILabel* lbStatus;
    
}

@property (nonatomic, readonly) UIButton* operateButton;

- (void) setHealthPlanStatus:(NSInteger) status;
@end

@implementation HealthPlanMessionStatusView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self showTopLine];
        lbStatus = [[UILabel alloc]init];
        [self addSubview:lbStatus];
        [lbStatus setTextColor:[UIColor commonGrayTextColor]];
        [lbStatus setFont:[UIFont systemFontOfSize:13]];
        
        [lbStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(6.5);
            make.centerY.equalTo(self);
        }];
        
        _operateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_operateButton];
        [_operateButton setBackgroundImage:[UIImage rectImage:CGSizeMake(80, 32) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_operateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _operateButton.layer.cornerRadius = 2.5;
        _operateButton.layer.masksToBounds = YES;
        [_operateButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_operateButton setHidden:YES];
        //[operateButton setEnabled:NO];
        
        [_operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.mas_equalTo(@30);
            make.right.mas_equalTo(self).with.offset(-12.5);
        }];
    }
    return self;
}

- (void) setHealthPlanStatus:(NSInteger) status
{
    [_operateButton setHidden:YES];
    NSString* buttonStr = nil;
    switch (status)
    {
        case 1:
        {
            [lbStatus setText:@"待制定"];
            buttonStr = @"制定";
        }
            break;
        case 2:
        {
            [lbStatus setText:@"待确认"];
            buttonStr = @"浏览并确定";
        }
            break;
        case 3:
        {
            [lbStatus setText:@"待调整"];
            buttonStr = @"调整";
        }
            break;
        case 5:
        {
            [lbStatus setText:@"已终止"];
        }
            break;
        case 6:
        {
            [lbStatus setText:@"已过期"];
        }
            break;
        case 7:
        {
            [lbStatus setText:@"执行中"];
            buttonStr = @"编辑";
        }
            break;
        case 8:
        {
            [lbStatus setText:@"草稿"];
            buttonStr = @"编辑";
        }
            break;
        default:
        {
            [lbStatus setText:@" "];
        }
            break;
            break;
    }
    
    if (buttonStr && 0 < buttonStr.length) {
        [_operateButton setHidden:NO];
        [_operateButton setTitle:buttonStr forState:UIControlStateNormal];
        [_operateButton mas_updateConstraints:^(MASConstraintMaker *make) {
            CGFloat buttonWidth = 20 + [buttonStr widthSystemFont:[UIFont systemFontOfSize:14]];
            make.width.mas_equalTo([NSNumber numberWithFloat:buttonWidth]);
        }];
    }
}
@end

@interface HealthPlanMessionView : UIView
{
    UIImageView* ivPartrait;
    UILabel* lbUserName;
    UILabel* lbUserInfo;
    
    UILabel* lbDurationTitle;
    UILabel* lbDuration;
    
    UILabel* lbContentTitle;
    UILabel* lbContent;
    
    UILabel* lbTeamTitle;
    UILabel* lbTeamName;
    
    HealthPlanMessionStatusView* statusview;
}
@property (nonatomic, readonly) UIButton* archiveButton;
@property (nonatomic, readonly) UIButton* operateButton;

- (void) setHealthPlan:(HealthPlanMessionInfo*) healthPlan;
@end

@implementation HealthPlanMessionView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        ivPartrait = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_default_user"]];
        [self addSubview:ivPartrait];
        ivPartrait.layer.cornerRadius = 2.5;
        ivPartrait.layer.masksToBounds = YES;
        
        [ivPartrait mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.equalTo(self).with.offset(13);
        }];
        
        lbUserName = [[UILabel alloc]init];
        [self addSubview:lbUserName];
        [lbUserName setTextColor:[UIColor commonTextColor]];
        [lbUserName setFont:[UIFont systemFontOfSize:15]];
        
        [lbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ivPartrait.mas_right).with.offset(6);
            make.top.equalTo(ivPartrait);
        }];
        
        _archiveButton = [[UIButton alloc] init];
        [self addSubview:_archiveButton];
        [_archiveButton setTitle:@"档案详情 >" forState:UIControlStateNormal];
        [_archiveButton setTitleColor:[UIColor commonLightGrayTextColor] forState:UIControlStateNormal];
        [_archiveButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_archiveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-12.5);
            make.top.equalTo(lbUserName).offset(-5);
        }];
        
        lbUserInfo = [[UILabel alloc]init];
        [self addSubview:lbUserInfo];
        [lbUserInfo setTextColor:[UIColor commonTextColor]];
        [lbUserInfo setFont:[UIFont systemFontOfSize:14]];
        
        [lbUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName.mas_right).with.offset(2);
            make.top.equalTo(lbUserName).with.offset(1);
            make.right.lessThanOrEqualTo(_archiveButton.mas_left);
        }];
        
        lbDurationTitle = [[UILabel alloc]init];
        [self addSubview:lbDurationTitle];
        [lbDurationTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbDurationTitle setFont:[UIFont systemFontOfSize:13]];
        [lbDurationTitle setText:@"服务期限:"];
        [lbDurationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName);
            make.top.equalTo(lbUserName.mas_bottom).with.offset(13);
        }];
        
        lbDuration = [[UILabel alloc]init];
        [self addSubview:lbDuration];
        [lbDuration setTextColor:[UIColor commonGrayTextColor]];
        [lbDuration setFont:[UIFont systemFontOfSize:13]];
        
        [lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbDurationTitle.mas_right);
            make.top.equalTo(lbDurationTitle);
        }];

        lbContentTitle = [[UILabel alloc]init];
        [self addSubview:lbContentTitle];
        [lbContentTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbContentTitle setFont:[UIFont systemFontOfSize:13]];
        [lbContentTitle setText:@"服务套餐:"];
        [lbContentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName);
            make.top.equalTo(lbDurationTitle.mas_bottom).with.offset(5);
        }];
        
        lbContent = [[UILabel alloc]init];
        [self addSubview:lbContent];
        [lbContent setTextColor:[UIColor commonGrayTextColor]];
        [lbContent setFont:[UIFont systemFontOfSize:13]];
        
        [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbContentTitle.mas_right);
            make.top.equalTo(lbContentTitle);
            make.right.lessThanOrEqualTo(self.mas_right).offset(-5);
        }];
        
        lbTeamTitle = [[UILabel alloc]init];
        [self addSubview:lbTeamTitle];
        [lbTeamTitle setTextColor:[UIColor commonGrayTextColor]];
        [lbTeamTitle setFont:[UIFont systemFontOfSize:13]];
        [lbTeamTitle setText:@"服务团队:"];
        [lbTeamTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbUserName);
            make.top.equalTo(lbContentTitle.mas_bottom).with.offset(5);
        }];
        
        lbTeamName = [[UILabel alloc]init];
        [self addSubview:lbTeamName];
        [lbTeamName setTextColor:[UIColor commonGrayTextColor]];
        [lbTeamName setFont:[UIFont systemFontOfSize:13]];
        
        [lbTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lbTeamTitle.mas_right);
            make.top.equalTo(lbTeamTitle);
        }];
        
        statusview = [[HealthPlanMessionStatusView alloc]init];
        [self addSubview:statusview];
        [statusview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(@40);
        }];

    }
    return self;
}

- (UIButton*) operateButton
{
    return statusview.operateButton;
}

- (void) setHealthPlan:(HealthPlanMessionInfo*) healthPlan
{
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [ivPartrait sd_setImageWithURL:[NSURL URLWithString:healthPlan.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_user"]];
    
    [lbUserName setText:healthPlan.userName];
    
    if (kStringIsEmpty(healthPlan.illName)) {
        [lbUserInfo setText:[NSString stringWithFormat:@"(%@|%ld)", healthPlan.sex, healthPlan.age]];
    }
    else{
        [lbUserInfo setText:[NSString stringWithFormat:@"(%@|%ld %@)", healthPlan.sex, healthPlan.age,healthPlan.mainIll]];
    }

//    NSDate* dtBegin = [NSDate dateWithString:healthPlan.beginTime formatString:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate* dtEnd = [NSDate dateWithString:healthPlan.endTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    [lbDuration setText:[NSString stringWithFormat:@"%@ ~ %@", healthPlan.beginTime, healthPlan.endTime]];
    [lbContent setText:healthPlan.productName];
    
    [lbTeamName setText:healthPlan.teamName];
    
    [statusview setHealthPlanStatus:healthPlan.status];
}
@end

@interface HealthPlanMessionTableViewCell ()
{
    HealthPlanMessionView* recordview;
}
@end

@implementation HealthPlanMessionTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        
        recordview = [[HealthPlanMessionView alloc]init];
        
        [self.contentView addSubview:recordview];
        [recordview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(10);
            make.bottom.equalTo(self.contentView);
        }];
        
        recordview.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        recordview.layer.borderWidth = 0.5;
        recordview.layer.cornerRadius = 4;
        recordview.layer.masksToBounds = YES;
    }
    return self;
}

- (void) setHealthPlan:(HealthPlanMessionInfo*) healthPlan
{
    [recordview setHealthPlan:healthPlan];
}

- (UIButton*) operateButton
{
    return recordview.operateButton;
}

- (UIButton *)archiveButton
{
    return recordview.archiveButton;
}
@end

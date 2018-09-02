//
//  PersonServiceTableViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/7/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonServiceTableViewCell.h"
#import "TeamInfo.h"
@implementation UserServiceInfo (PersonServiceCellHeight)

- (CGFloat) tableCellHeight
{
    CGFloat cellHeight = 85;
    
    if (self.dets)
    {
        NSInteger row = self.dets.count/4;
        if (0 < self.dets.count % 4) {
            ++row;
        }
        
        cellHeight += row * 102;
    }
    return cellHeight;
}

@end

@interface PersonServiceDetCell : UIView
{
    UIImageView* ivIcon;
    UILabel* lbDetName;
    UILabel* lbBillway;
}

- (void) setUserServiceDetInfo:(UserServiceDetInfo*) detInfo;
@end

@implementation PersonServiceDetCell

- (id) init
{
    self = [super init];
    if (self)
    {
        ivIcon = [[UIImageView alloc]init];
        [self addSubview:ivIcon];
        [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).with.offset(18);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        lbDetName = [[UILabel alloc]init];
        [self addSubview:lbDetName];
        [lbDetName setTextColor:[UIColor commonTextColor]];
        [lbDetName setFont:[UIFont font_30]];
        
        [lbDetName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.lessThanOrEqualTo(self);
            make.top.equalTo(ivIcon.mas_bottom).with.offset(6);
        }];
        
        lbBillway = [[UILabel alloc]init];
        [self addSubview:lbBillway];
        [lbBillway setTextColor:[UIColor commonGrayTextColor]];
        [lbBillway setFont:[UIFont font_26]];
        
        [lbBillway mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.lessThanOrEqualTo(self);
            make.top.equalTo(lbDetName.mas_bottom).with.offset(4);
        }];

    }
    return self;
}

- (void) setUserServiceDetInfo:(UserServiceDetInfo*) detInfo
{
    if (detInfo.imgUrl)
    {
        [ivIcon sd_setImageWithURL:[NSURL URLWithString:detInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_service_default"]];
    }
    
    [lbDetName setText:detInfo.childProductName];
    if (0 == detInfo.maxNum)
    {
        [lbBillway setText:[NSString stringWithFormat:@"不限次数"]];
        
    }
    else
    {
        [lbBillway setText:[NSString stringWithFormat:@"剩%ld次", detInfo.remainNum]];

    }
}

@end

@interface PersonServiceTableViewCell ()
{
    UIView* serviceview;
    
    UILabel* lbServiceName;
    UILabel* lbServiceProvider;
    UILabel* lbServiceDuration;
    UIImageView* ivStatus;
    
    UIView* serviceDetsView;
    UIButton* updateServiceButton;
    
    NSInteger teamId;
    NSString* teamName;
}


@end

@implementation PersonServiceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor commonBackgroundColor]];
        serviceview = [[UIView alloc]init];
        [serviceview setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:serviceview];
        
        [serviceview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(@80);
            make.top.equalTo(self.contentView).with.offset(5);
        }];
        [serviceview showBottomLine];
        
        lbServiceName = [[UILabel alloc]init];
        [serviceview addSubview:lbServiceName];
        [lbServiceName setTextColor:[UIColor commonTextColor]];
        [lbServiceName setFont:[UIFont font_30]];
        [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(serviceview).with.offset(12.5);
            make.right.lessThanOrEqualTo(serviceview).with.offset(-12.5);
            make.top.equalTo(serviceview).with.offset(10.5);
        }];
        
        lbServiceDuration = [[UILabel alloc]init];
        [serviceview addSubview:lbServiceDuration];
        [lbServiceDuration setTextColor:[UIColor commonGrayTextColor]];
        [lbServiceDuration setFont:[UIFont font_24]];
        [lbServiceDuration mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(serviceview).with.offset(12.5);
            make.right.lessThanOrEqualTo(serviceview).with.offset(-12.5);
            make.top.equalTo(lbServiceName.mas_bottom).with.offset(5);
        }];
        
        lbServiceProvider = [[UILabel alloc]init];
        [serviceview addSubview:lbServiceProvider];
        [lbServiceProvider setTextColor:[UIColor commonGrayTextColor]];
        [lbServiceProvider setFont:[UIFont font_24]];
        [lbServiceProvider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(serviceview).with.offset(12.5);
            make.right.lessThanOrEqualTo(serviceview).with.offset(-12.5);
            make.top.equalTo(lbServiceDuration.mas_bottom).with.offset(5);
        }];
        
        ivStatus = [[UIImageView alloc]init];
        [serviceview addSubview:ivStatus];
        [ivStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(serviceview);
            make.right.equalTo(serviceview).with.offset(-4);
            make.size.mas_equalTo(CGSizeMake(79, 49));
        }];

        serviceDetsView = [[UIView alloc]init];
        [self.contentView addSubview:serviceDetsView];
        [serviceDetsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(serviceview.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
        
        [serviceDetsView setBackgroundColor:[UIColor whiteColor]];
        
        updateServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:updateServiceButton];
        [updateServiceButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [updateServiceButton setTitle:@"升级VIP服务" forState:UIControlStateNormal];
        [updateServiceButton.titleLabel setFont:[UIFont font_24]];
        [updateServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        updateServiceButton.layer.cornerRadius = 2.5;
        updateServiceButton.layer.masksToBounds = YES;
        [updateServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 30));
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.top.equalTo(self.contentView).with.offset(7.5);
        }];
        [updateServiceButton setHidden:YES];
        [updateServiceButton addTarget:self action:@selector(updateServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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

- (void) updateServiceButtonClicked:(id) sender
{
    if (0 == teamId)
    {
        return;
    }
    //跳转到服务订购列表
//    [HMViewControllerManager createViewControllerWithControllerName:@"ServiceCategoryStartViewController" ControllerObject:nil];
    
    //跳转到服务团队 TeamDetailViewController
    TeamInfo* team = [[TeamInfo alloc]init];
    [team setTeamId:teamId];
    [team setTeamName:teamName];
    [team setTeamControllerFlag:1];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"TeamDetailViewController" ControllerObject:team];
}

- (void) setUserService:(UserServiceInfo*) userService
{
    [lbServiceName setText:userService.serviceName];
    
    if (userService.provideTeamId)
    {
        teamId = userService.provideTeamId.integerValue;
        teamName = userService.provideTeamName;
    }
    
    
    NSDate* dateBegin = [NSDate dateWithString:userService.beginTime formatString:@"yyyy-MM-dd"];
    if (!dateBegin)
    {
        dateBegin = [NSDate dateWithString:userService.beginTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate* dateEnd = [NSDate dateWithString:userService.endTime formatString:@"yyyy-MM-dd"];
    if (!dateEnd)
    {
        dateEnd = [NSDate dateWithString:userService.endTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString* beginStr = [dateBegin formattedDateWithFormat:@"yyyy年MM月dd日"];
    NSString* endStr = [dateEnd formattedDateWithFormat:@"yyyy年MM月dd日"];
    NSString* durationStr = [NSString stringWithFormat:@"服务期限:"];
    if (beginStr && endStr)
    {
        durationStr = [durationStr stringByAppendingFormat:@" %@ ~ %@", beginStr, endStr];
    }
    [lbServiceDuration setText: durationStr];
    
    NSString* providerStr = [NSString stringWithFormat:@"服务者: %@", userService.providerName];
    if (userService.orgName && 0 < userService.orgName.length)
    {
        providerStr = [providerStr stringByAppendingFormat:@"(%@)", userService.orgName];
    }
    [lbServiceProvider setText:providerStr];
    
    switch (userService.status)
    {
        case 1:
        {
            [ivStatus setImage:[UIImage imageNamed:@"icon_myservice_unpayed"]];
        }
            break;
        case 2:
        {
            [ivStatus setImage:[UIImage imageNamed:@"icon_myservice_inservice"]];
        }
            break;
        case 3:
        {
            [ivStatus setImage:[UIImage imageNamed:@"icon_myservice_expired"]];
        }
            break;
        case 4:
        {
            [ivStatus setImage:[UIImage imageNamed:@"icon_myservice_cancel"]];
        }
            break;
        case 6:
        {
            [ivStatus setImage:[UIImage imageNamed:@"img-fp"]];
        }
            break;
        default:
            break;
    }
    [self createDetCells:userService.dets];
    
    [ivStatus setHidden:NO];
    [updateServiceButton setHidden:YES];
    
    if (2 == userService.status)
    {
        switch (userService.classify)
        {
            case 0:
            case 1:
            case 2:
            {
                //正式服务
                [ivStatus setHidden:NO];
                [updateServiceButton setHidden:YES];
            }
                break;
            case 3:
            case 4:
            {
                //基础服务、试用服务，可升级
                if (!userService.provideTeamId) {
                    [ivStatus setHidden:NO];
                    [updateServiceButton setHidden:YES];
                }
                else
                {
                    [ivStatus setHidden:YES];
                    [updateServiceButton setHidden:NO];
                }
                
                
            }
                break;
            default:
                break;
        }

    }
}

- (void) createDetCells:(NSArray*) dets
{
    NSArray* subviews = [serviceDetsView subviews];
    for (PersonServiceDetCell* cell in subviews)
    {
        [cell removeFromSuperview];
    }
    
    if (!dets || 0 == dets.count)
    {
        return;
    }
    
    MASViewAttribute* masLeft = serviceDetsView.mas_left;
    MASViewAttribute* masTop = serviceDetsView.mas_top;
    
    PersonServiceDetCell* perCell = nil;
    
    for (NSInteger index = 0; index < dets.count; ++index)
    {
        UserServiceDetInfo* detInfo = dets[index];
        PersonServiceDetCell* cell = [[PersonServiceDetCell alloc]init];
        [serviceDetsView addSubview:cell];
        [cell setUserServiceDetInfo:detInfo];
        
        if (perCell)
        {
            if (0 == index % 4)
            {
                masLeft = serviceDetsView.mas_left;
                masTop = perCell.mas_bottom;
            }
            else
            {
                masLeft = perCell.mas_right;
                masTop = perCell.mas_top;
            }
        }
        
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(masLeft);
            make.top.equalTo(masTop);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/4, 102));
        }];
        
        perCell = cell;
    }
    
    
}
@end

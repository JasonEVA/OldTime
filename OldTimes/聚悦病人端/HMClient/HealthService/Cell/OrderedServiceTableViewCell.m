//
//  OrderedServiceTableViewCell.m
//  JYHMUser
//
//  Created by yinquan on 16/11/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "OrderedServiceTableViewCell.h"
#import "ServiceInfo.h"
#import "TeamInfo.h"

@implementation OrderedServiceModel (TableViewCellHeight)

- (CGFloat) tableCellHeight
{
    CGFloat tableCellHeihgt = 86;
    
    if (self.dets)
    {
        NSInteger rows = self.dets.count / 4;
        if (self.dets.count % 4 > 0) {
            ++rows;
        }
        tableCellHeihgt += 102 * kScreenWidthScale * rows;
    }
    return tableCellHeihgt;
}

- (BOOL) showUpdateButton
{
    if (![self isBasicService])
    {
        //不是基础服务
        return NO;
    }
    if (self.status != 2) {
        //不是服务中的服务
        return NO;
    }
    
    return YES;
}

@end

@interface OrderedServiceSummaryView ()
{
    UIButton* updateServiceButton;
}
@property (nonatomic, readonly) UILabel* titleLable;
@property (nonatomic, readonly) UILabel* durationLable;
@property (nonatomic, readonly) UILabel* providerLable;
@property (nonatomic, readonly) UIImageView* statusIamgeView;

@property (nonatomic, readonly) NSInteger teamId;
@property (nonatomic, readonly) NSString* teamName;

- (void) setOrderedService:(OrderedServiceModel*) orderedService;
@end

@implementation OrderedServiceSummaryView

- (id) init
{
    self = [super init];
    if (self) {
        _titleLable = [[UILabel alloc]init];
        [self addSubview:_titleLable];
        [_titleLable setTextColor:[UIColor commonTextColor]];
        [_titleLable setFont:[UIFont font_30]];
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.right.lessThanOrEqualTo(self).with.offset(-12.5);
            make.top.equalTo(self).offset(10);
        }];
        
        _durationLable = [[UILabel alloc]init];
        [self addSubview:_durationLable];
        [self.durationLable setTextColor:[UIColor commonGrayTextColor]];
        [self.durationLable setFont:[UIFont font_26]];
        [self.durationLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.right.lessThanOrEqualTo(self).with.offset(-12.5);
            make.top.equalTo(self.titleLable.mas_bottom).offset(5);
        }];
        
        _providerLable = [[UILabel alloc]init];
        [self addSubview:_providerLable];
        [self.providerLable setTextColor:[UIColor commonGrayTextColor]];
        [self.providerLable setFont:[UIFont font_26]];
        [self.providerLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.right.lessThanOrEqualTo(self).with.offset(-12.5);
            make.top.equalTo(self.durationLable.mas_bottom).offset(3);
        }];

        _statusIamgeView = [[UIImageView alloc]init];
        [self addSubview:self.statusIamgeView];
        [self.statusIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.centerY.equalTo(serviceview);
            make.top.equalTo(self).with.offset(7);
            make.right.equalTo(self).with.offset(-4);
            make.size.mas_equalTo(CGSizeMake(40, 25));
        }];
        
        updateServiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:updateServiceButton];
        [updateServiceButton setBackgroundImage:[UIImage rectImage:CGSizeMake(120, 40) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [updateServiceButton setTitle:@"升级VIP服务" forState:UIControlStateNormal];
        [updateServiceButton.titleLabel setFont:[UIFont font_24]];
        [updateServiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        updateServiceButton.layer.cornerRadius = 2.5;
        updateServiceButton.layer.masksToBounds = YES;
        [updateServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(90, 30));
            make.right.equalTo(self).with.offset(-12.5);
            make.top.equalTo(self).with.offset(7.5);
        }];
        [updateServiceButton setHidden:YES];
        [updateServiceButton addTarget:self action:@selector(updateServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self showBottomLine];
    }
    return self;
}

- (void) setOrderedService:(OrderedServiceModel*) orderedService
{
    _teamId = orderedService.provideTeamId;
    _teamName = orderedService.provideTeamName;
    
    [self.titleLable setText:orderedService.productName];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* beginDate = [formatter dateFromString:orderedService.beginTime];
    NSDate* endDate = [formatter dateFromString:orderedService.endTime];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString* beginString = [formatter stringFromDate:beginDate];
    NSString* endString = [formatter stringFromDate:endDate];
    
    NSString* duartionString = [NSString stringWithFormat:@"服务期限:%@~%@", beginString, endString];
    [self.durationLable setText:duartionString];
    
    NSString* providerString = @"";
    if (orderedService.provider) {
        providerString = orderedService.provider;
    }
    if (orderedService.orgName && orderedService.orgName.length > 0) {
        providerString = [providerString stringByAppendingFormat:@"(%@)", orderedService.orgName];
    }
    [self.providerLable setText:[NSString stringWithFormat:@"服务者:%@", providerString]];
    
    BOOL showUpdateButton = [orderedService showUpdateButton];
    [self.statusIamgeView setHidden:showUpdateButton];
    [updateServiceButton setHidden:!showUpdateButton];
    
    if ([orderedService showUpdateButton])
    {
        //显示升级VIP服务按钮
        
    }
    else
    {
        switch (orderedService.status)
        {
            case 1:
            {
                [self.statusIamgeView setImage:[UIImage imageNamed:@"icon_myservice_unpayed"]];
            }
                break;
            case 2:
            {
                [self.statusIamgeView setImage:[UIImage imageNamed:@"icon_myservice_inservice"]];
            }
                break;
            case 3:
            {
                [self.statusIamgeView setImage:[UIImage imageNamed:@"icon_myservice_expired"]];
            }
                break;
            case 4:
            {
                [self.statusIamgeView setImage:[UIImage imageNamed:@"icon_myservice_cancel"]];
            }
                break;
            case 6:
            {
                [self.statusIamgeView setImage:[UIImage imageNamed:@"img-fp"]];
            }
                break;
            default:
                break;
        }

    }
    
}

- (void) updateServiceButtonClicked:(id) sender
{
    if (0 == self.teamId)
    {
        return;
    }
    
    //跳转到服务团队 TeamDetailViewController
    TeamInfo* team = [[TeamInfo alloc]init];
    [team setTeamId:self.teamId];
    [team setTeamName:self.teamName];
    [team setTeamControllerFlag:1];
    
    [HMViewControllerManager createViewControllerWithControllerName:@"TeamDetailViewController" ControllerObject:team];
    
}

@end

@interface OrderedServiceDetsCell : UIControl
{
    
}

@property (nonatomic, readonly) UIImageView* detImageView;
@property (nonatomic, readonly) UILabel* detNameLable;
@property (nonatomic, readonly) UILabel* remainLable;

@end

@implementation OrderedServiceDetsCell

- (id) initWithServiceDet:(UserServiceDet*) serviceDet
{
    self = [super init];
    if (self) {
        _detImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_service_default"]];
        [self addSubview:self.detImageView];
        [self.detImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.equalTo(self).with.offset(12);
        }];
        [self.detImageView sd_setImageWithURL:[NSURL URLWithString:serviceDet.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_service_default"]];
        
        _detNameLable = [[UILabel alloc] init];
        [self addSubview:self.detNameLable];
//        [self.detNameLable setFont:[UIFont font_30]];
        [self.detNameLable setFont:[UIFont systemFontOfSize:15]];
        [self.detNameLable setTextColor:[UIColor commonTextColor]];
        [self.detNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.detImageView.mas_bottom).with.offset(8);
            make.width.lessThanOrEqualTo(self).with.offset(-5);
        }];
        [self.detNameLable setText:serviceDet.childProductName];
        
        _remainLable = [[UILabel alloc] init];
        [self addSubview:self.remainLable];
        [self.remainLable setFont:[UIFont font_26]];
        [self.remainLable setTextColor:[UIColor commonGrayTextColor]];
        [self.remainLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.detNameLable.mas_bottom).with.offset(3);
            make.width.lessThanOrEqualTo(self).with.offset(-5);
        }];
        
        if (serviceDet.subClassify == 0) {
            [self.remainLable setText:@""];
        }
        else if (0 == serviceDet.maxNum)
        {
            [self.remainLable setText:[NSString stringWithFormat:@"不限次数"]];
        }
        else
        {
            [self.remainLable setText:[NSString stringWithFormat:@"剩%ld次", serviceDet.remainNum]];
        }
        
    }
    return self;
}

@end

@interface OrderedServiceDetsView ()
{
    ;
    NSMutableArray* serviceDetCells;
}
@property (nonatomic, readonly) NSArray* serviceDets;
- (void) setServiceDets:(NSArray*) servicesDets;
@end

@implementation OrderedServiceDetsView

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void) setServiceDets:(NSArray*) servicesDets
{
    _serviceDets = servicesDets;
    if (serviceDetCells) {
        [serviceDetCells enumerateObjectsUsingBlock:^(OrderedServiceDetsCell* cell, NSUInteger idx, BOOL * _Nonnull stop) {
            [cell removeFromSuperview];
        }];
        [serviceDetCells removeAllObjects];
    }
    else
    {
        serviceDetCells = [NSMutableArray array];
    }
    MASViewAttribute* cellLeft = self.mas_left;
    MASViewAttribute* cellTop = self.mas_top;
    for (NSInteger index = 0; index < servicesDets.count; ++index)
    {
        UserServiceDet* serviceDet = servicesDets[index];
        OrderedServiceDetsCell* cell = [[OrderedServiceDetsCell alloc]initWithServiceDet:serviceDet];
        
        [self addSubview:cell];
        
        if (index % 4 == 0) {
            cellLeft = self.mas_left;
        }
        OrderedServiceDetsCell* perCell = [serviceDetCells lastObject];
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kScreenWidth/4, 102 * kScreenWidthScale));
            
            make.left.equalTo(cellLeft);
            make.top.equalTo(cellTop);
            if (perCell) {
                make.width.equalTo(perCell);
            }
            
        }];
        cellLeft = cell.mas_right;
        if (index % 4 == 3) {
            cellTop = cell.mas_bottom;
        }
        [cell addTarget:self action:@selector(serviceDetCellClicked:) forControlEvents:UIControlEventTouchUpInside];
        [serviceDetCells addObject:cell];
    }
}

- (void) serviceDetCellClicked:(id) sender
{
    if (![sender isKindOfClass:[OrderedServiceDetsCell class]])
    {
        return;
    }
    NSInteger clickIndex = [serviceDetCells indexOfObject:sender];
    if (clickIndex == NSNotFound ) {
        return;
    }
    
    UserServiceDet* serviceDet = self.serviceDets[clickIndex];
    [HMViewControllerManager createViewControllerWithControllerName:@"OrderedServiceDetDetailViewController" ControllerObject:serviceDet];
}
@end

@interface OrderedServiceTableViewCell ()
{
    
}

@end

@implementation OrderedServiceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _serviecSummaryView = [[OrderedServiceSummaryView alloc]init];
        [self.contentView addSubview:self.serviecSummaryView];
        [self.serviecSummaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView);
            make.height.mas_equalTo(@86);
        }];
        
        _serviceDetsView = [[OrderedServiceDetsView alloc]init];
        [self.contentView addSubview:self.serviceDetsView];
        [self.serviceDetsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.top.equalTo(self.serviecSummaryView.mas_bottom);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void) setOrderedService:(OrderedServiceModel*) orderedService
{
    [self.serviecSummaryView setOrderedService:orderedService];
    [self.serviceDetsView setServiceDets:orderedService.dets];
}
@end

@interface OrderedAppreciationServiceTableViewCell ()

@property (nonatomic, readonly) NSInteger upId;
@property (nonatomic, readonly) UILabel* serviceNameLable;
@property (nonatomic, readonly) UILabel* remainLable;

@property (nonatomic, readonly) UILabel* durationLable;
@property (nonatomic, readonly) UILabel* providerLable;

@property (nonatomic, readonly) UIImageView* ivStatus;
@property (nonatomic, readonly) UIButton* orderButton;
@end

@implementation OrderedAppreciationServiceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _serviceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_service_default"]];
        [self.contentView addSubview:self.serviceImageView];
        
        [self.serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(self.contentView).with.offset(10);
        }];
        
        _serviceNameLable = [[UILabel alloc]init];
        [self.contentView addSubview:self.serviceNameLable];
        [self.serviceNameLable setFont:[UIFont font_30]];
        [self.serviceNameLable setTextColor:[UIColor commonTextColor]];
        
        [self.serviceNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.serviceImageView.mas_right).with.offset(12);
            make.top.equalTo(self.serviceImageView);
            make.right.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];
        
        _remainLable = [[UILabel alloc]init];
        [self.contentView addSubview:self.remainLable];
        [self.remainLable setFont:[UIFont font_24]];
        [self.remainLable setTextColor:[UIColor commonGrayTextColor]];
        
        [self.remainLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.serviceNameLable.mas_right).with.offset(12);
            make.bottom.equalTo(self.serviceNameLable);
            make.right.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];
        
        _durationLable = [[UILabel alloc]init];
        [self.contentView addSubview:self.durationLable];
        [self.durationLable setFont:[UIFont font_22]];
        [self.durationLable setTextColor:[UIColor commonGrayTextColor]];
        [self.durationLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(self.serviceImageView.mas_bottom).with.offset(4);
            make.right.right.lessThanOrEqualTo(self.contentView).with.offset(-90);
        }];
        
        _providerLable = [[UILabel alloc]init];
        [self.contentView addSubview:self.providerLable];
        [self.providerLable setFont:[UIFont font_22]];
        [self.providerLable setTextColor:[UIColor commonGrayTextColor]];
        [self.providerLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(self.durationLable.mas_bottom).with.offset(3);
            make.right.right.lessThanOrEqualTo(self.contentView).with.offset(-90);
        }];
        
        _ivStatus = [[UIImageView alloc]init];
        [self.contentView addSubview:self.ivStatus];
        [self.ivStatus mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(serviceview);
            make.top.equalTo(self.contentView).with.offset(7);
            make.right.equalTo(self.contentView).with.offset(-4);
            make.size.mas_equalTo(CGSizeMake(40, 25));
        }];
        
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.orderButton];
        [self.orderButton setBackgroundImage:[UIImage rectImage:CGSizeMake(75, 30) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [self.orderButton setTitle:@"继续订购" forState:UIControlStateNormal];
        [self.orderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.orderButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        self.orderButton.layer.cornerRadius = 2.5;
        self.orderButton.layer.masksToBounds = YES;
        [self.orderButton setHidden:YES];
        [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 30));
            make.top.equalTo(self.durationLable);
            make.right.equalTo(self.contentView).with.offset(-12.5);
        }];
        
        [self.orderButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) setOrderedService:(OrderedServiceModel*) orderedService
{
    if (!orderedService.dets || orderedService.dets.count == 0) {
        return;
    }
    
    _upId = orderedService.upId;
    
    UserServiceDet* serviceDet = [orderedService.dets firstObject];
    [self.serviceImageView sd_setImageWithURL:[NSURL URLWithString:serviceDet.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_service_default"]];
    
    [self.serviceNameLable setText:serviceDet.childProductName];
    if (0 == serviceDet.maxNum)
    {
        [self.remainLable setText:[NSString stringWithFormat:@"不限次数"]];
    }
    else
    {
        [self.remainLable setText:[NSString stringWithFormat:@"剩%ld次", serviceDet.remainNum]];
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* beginDate = [formatter dateFromString:orderedService.beginTime];
    NSDate* endDate = [formatter dateFromString:orderedService.endTime];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString* beginString = [formatter stringFromDate:beginDate];
    NSString* endString = [formatter stringFromDate:endDate];
    
    NSString* duartionString = [NSString stringWithFormat:@"服务期限:%@~%@", beginString, endString];
    [self.durationLable setText:duartionString];
    
    NSString* providerString = @"";
    if (orderedService.provider) {
        providerString = orderedService.provider;
    }
    
    [self.providerLable setText:[NSString stringWithFormat:@"服务者:%@", providerString]];
    
    switch (orderedService.status)
    {
        case 1:
        {
            [self.ivStatus setImage:[UIImage imageNamed:@"icon_myservice_unpayed"]];
        }
            break;
        case 2:
        {
            [self.ivStatus setImage:[UIImage imageNamed:@"icon_myservice_inservice"]];
        }
            break;
        case 3:
        {
            [self.ivStatus setImage:[UIImage imageNamed:@"icon_myservice_expired"]];
        }
            break;
        case 4:
        {
            [self.ivStatus setImage:[UIImage imageNamed:@"icon_myservice_cancel"]];
        }
            break;
        case 6:
        {
            [self.ivStatus setImage:[UIImage imageNamed:@"img-fp"]];
        }
            break;
        default:
            break;
    }
    
    BOOL hideOrderButton = YES;
    if (serviceDet.remainNum == 0 && serviceDet.maxNum > 0) {
        //剩余次数为0
        hideOrderButton = NO;
    }
    NSTimeInterval tiEnd = [endDate timeIntervalSinceNow];
    if (tiEnd < 0) {
        //服务到期
        hideOrderButton = NO;
    }
    [self.orderButton setHidden:hideOrderButton];
}

- (void) orderButtonClicked:(id) sender
{
    ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
    [serviceInfo setUpId:self.upId];
//    [HMViewControllerManager createViewControllerWithControllerName:@"ServiceDetailStartViewController" FromControllerId:nil ControllerObject:serviceInfo];
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
}
@end

@interface OrderedAppreciationGoodsTableViewCell ()

@property (nonatomic, readonly) UILabel* serviceNameLable;

@end

@implementation OrderedAppreciationGoodsTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _serviceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_service_default"]];
        [self.contentView addSubview:self.serviceImageView];
        
        [self.serviceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.left.equalTo(self.contentView).with.offset(12.5);
            make.top.equalTo(self.contentView).with.offset(10);
        }];
        
        _serviceNameLable = [[UILabel alloc]init];
        [self.contentView addSubview:self.serviceNameLable];
        [self.serviceNameLable setFont:[UIFont font_30]];
        [self.serviceNameLable setTextColor:[UIColor commonTextColor]];
        
        [self.serviceNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.serviceImageView.mas_right).with.offset(12);
            make.centerY.equalTo(self.serviceImageView);
            make.right.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5);
        }];

    }
    return self;
}

- (void) setOrderedService:(OrderedServiceModel*) orderedService
{
    if (!orderedService.dets || orderedService.dets.count == 0) {
        return;
    }
    UserServiceDet* serviceDet = [orderedService.dets firstObject];
    [self.serviceImageView sd_setImageWithURL:[NSURL URLWithString:serviceDet.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_service_default"]];
    
    [self.serviceNameLable setText:serviceDet.childProductName];
}
@end

@implementation OrderedHistoryServiceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView* topView = [[UIView alloc]init];
        [self.contentView addSubview:topView];
        [topView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(@5);
        }];
        
        
        [self.serviecSummaryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).with.offset(5);
            make.left.right.right.equalTo(self.contentView);
            make.height.mas_equalTo(@86);
        }];
    }
    return self;
}

@end

@implementation OrderedHistoryAppreciationServiceTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView* topView = [[UIView alloc]init];
        [self.contentView addSubview:topView];
        [topView setBackgroundColor:[UIColor commonBackgroundColor]];

        [topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(@5);
        }];
        
        [self.serviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).with.offset(5);
        }];
    }
    return self;
}

@end

@implementation OrderedHistoryAppreciationGoodsTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView* topView = [[UIView alloc]init];
        [self.contentView addSubview:topView];
        [topView setBackgroundColor:[UIColor commonBackgroundColor]];
        
        [topView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.equalTo(self.contentView);
            make.height.mas_equalTo(@5);
        }];
        
        [self.serviceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.mas_bottom).with.offset(5);
        }];
    }
    return self;
}

@end

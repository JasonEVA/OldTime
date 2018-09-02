//
//  PersonSpaceServiceCollectionViewCell.m
//  HMClient
//
//  Created by yinqaun on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "PersonSpaceServiceCollectionViewCell.h"

@interface PersonServiceMoreButton : UIButton

@end

@implementation PersonServiceMoreButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect imageRect = CGRectMake((contentRect.size.width - 28)/2, (contentRect.size.height - 44)/2, 28, 28);
    return imageRect;
}

- (CGRect) titleRectForContentRect:(CGRect)contentRect
{
    CGRect titleRect = CGRectMake(0, (contentRect.size.height - 44)/2 + 28, contentRect.size.width, 16);
    return titleRect;
}

@end

@interface PersonSpaceServiceDetCell : UIView
{
    UILabel* lbName;
    UILabel* lbBillway;
    UIImageView* ivIcon;
}

- (void) setServiceDet:(UserServiceDetInfo*) serviceDet;
@end

@implementation PersonSpaceServiceDetCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        ivIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_service_default"]];
        [self addSubview:ivIcon];
        
        lbName = [[UILabel alloc]init];
        [lbName setTextColor:[UIColor commonTextColor]];
        [lbName setFont:[UIFont font_26]];
        [self addSubview:lbName];
        
        lbBillway = [[UILabel alloc]init];
        [lbBillway setTextColor:[UIColor commonGrayTextColor]];
        [lbBillway setFont:[UIFont font_24]];
        [self addSubview:lbBillway];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28, 28));
        make.centerX.equalTo(self);
        make.top.equalTo(self).with.offset(5);
    }];
    
    [lbName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(ivIcon.mas_bottom).with.offset(8.5);
        make.width.lessThanOrEqualTo(self);
    }];
    
    [lbBillway mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(lbName.mas_bottom).with.offset(4.5);
    }];
}

- (void) setServiceDet:(UserServiceDetInfo*) serviceDet
{
    if (serviceDet.imgUrl)
    {
        [ivIcon sd_setImageWithURL:[NSURL URLWithString:serviceDet.imgUrl] placeholderImage:[UIImage imageNamed:@"icon_service_default"]];
    }
    
    [lbName setText:serviceDet.childProductName];
    if (0 == serviceDet.maxNum)
    {
        [lbBillway setText:[NSString stringWithFormat:@"不限次数"]];

    }
    else
    {
        [lbBillway setText:[NSString stringWithFormat:@"剩%ld次", serviceDet.remainNum]];
        
    }
    
}

@end


@interface PersonSpaceServiceCollectionViewCell ()
{
    UILabel* lbServiceName;
    UILabel* lbDuration;
    
    UIView* serviceDetsView;
    UIButton* moreServiceButton;
}
@end

@implementation PersonSpaceServiceCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lbServiceName = [[UILabel alloc]init];
        [lbServiceName setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbServiceName setFont:[UIFont font_30]];
        [self.contentView addSubview:lbServiceName];
        
        lbDuration = [[UILabel alloc]init];
        [lbDuration setTextColor:[UIColor commonGrayTextColor]];
        [lbDuration setFont:[UIFont font_24]];
        [self.contentView addSubview:lbDuration];
        
        serviceDetsView = [[UIView alloc]init];
        [self.contentView addSubview:serviceDetsView];
        
        [self subviewLayout];
        
        [self createMoreServiceButton];
    }
    return self;
}

- (void) subviewLayout
{
    [lbServiceName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.5);
        make.top.equalTo(self.contentView).with.offset(10);
        make.right.lessThanOrEqualTo(lbDuration.mas_left).offset(-5).priorityHigh();
    }];
    
    [lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lbServiceName.mas_right).with.offset(5).priorityLow();
        make.bottom.equalTo(lbServiceName);
        make.right.lessThanOrEqualTo(self.contentView).with.offset(-12.5).priorityHigh();
    }];
    
    [serviceDetsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(@85);
    }];
}

- (void) createMoreServiceButton
{
    moreServiceButton = [PersonServiceMoreButton buttonWithType:UIButtonTypeCustom];
    [serviceDetsView addSubview:moreServiceButton];
    [moreServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(serviceDetsView);
        make.right.equalTo(serviceDetsView);
        make.width.mas_equalTo([NSNumber numberWithFloat:kScreenWidth/5]);
    }];
    
    [moreServiceButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreServiceButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
    [moreServiceButton.titleLabel setFont:[UIFont font_26]];
    [moreServiceButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [moreServiceButton setImage:[UIImage imageNamed:@"icon_user_more"] forState:UIControlStateNormal];
    [moreServiceButton addTarget:self action:@selector(moreServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) moreServiceButtonClicked:(id) sender
{
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－更多"];
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
}

/*- (void) setuserService:(UserServiceInfo*) userService
{
    [lbServiceName setText:userService.serviceName];
    
    NSDate* endDate = [NSDate dateWithString:userService.endTime formatString:@"yyyy-MM-dd"];
    if (!endDate)
    {
        endDate = [NSDate dateWithString:userService.endTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString* duraStr = [endDate formattedDateWithFormat:@"yyyy-MM-dd"];
    [lbDuration setText:[NSString stringWithFormat:@"服务期至 %@", duraStr]];
}*/

- (void) createUserServiceDets:(NSDictionary*) dicService
{
    NSString* endTime = [dicService objectForKey:@"endTime"];
    NSString* productName = [dicService objectForKey:@"productName"];
    NSArray* serviceDets = [dicService objectForKey:@"serviceDets"];
    
    [lbServiceName setText:productName];
    NSDate* endDate = [NSDate dateWithString:endTime formatString:@"yyyy-MM-dd"];
    if (!endDate)
    {
        endDate = [NSDate dateWithString:endTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSString* duraStr = [endDate formattedDateWithFormat:@"yyyy-MM-dd"];
    [lbDuration setText:[NSString stringWithFormat:@"服务期至 %@", duraStr]];
    
    
    NSArray* subviews = [serviceDetsView subviews];
    for (UIView* subview in subviews)
    {
        if (![subview isKindOfClass:[PersonSpaceServiceDetCell class]])
        {
            continue;
        }
        [subview removeFromSuperview];
    }
    
    CGFloat cellWidth = self.contentView.width/5;
    NSInteger maxCount = 4;
    if (maxCount > serviceDets.count)
    {
        maxCount = serviceDets.count;
    }
    
    for (NSInteger index = 0; index < maxCount; ++index)
    {
        CGRect rtCell = CGRectMake(cellWidth * index, 0, cellWidth, serviceDetsView.height);
        PersonSpaceServiceDetCell* cell = [[PersonSpaceServiceDetCell alloc]initWithFrame:rtCell];
        [serviceDetsView addSubview:cell];
        
        [cell setServiceDet:serviceDets[index]];
    }
}
@end

@interface PersonSpaceNoneServiceCollectionViewCell ()
{
    UILabel* lbNoneServie;
    UIButton* purchasebutton;
}
@end

@implementation PersonSpaceNoneServiceCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lbNoneServie = [[UILabel alloc]init];
        [self.contentView addSubview:lbNoneServie];
        [lbNoneServie setFont:[UIFont font_30]];
        [lbNoneServie setTextColor:[UIColor commonDarkGrayTextColor]];
        [lbNoneServie setText:@"您当前没有订购服务"];
        
        purchasebutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:purchasebutton];
        [purchasebutton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [purchasebutton setTitle:@"立即订购>>" forState:UIControlStateNormal];
        [purchasebutton.titleLabel setFont:[UIFont font_30]];
        [purchasebutton addTarget:self action:@selector(purchasebuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [lbNoneServie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(12.5);
    }];
    
    [purchasebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(lbNoneServie.mas_right).with.offset(28);
    }];
}

- (void) purchasebuttonClicked:(id) sender
{
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceStartViewController" ControllerObject:nil];
}

@end



@interface PersonSpaceAddedServiceCollectionViewCell ()
{
    UIView* serviceDetsView;
    UIButton* moreServiceButton;
}
@end

@implementation PersonSpaceAddedServiceCollectionViewCell

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        serviceDetsView = [[UIView alloc]init];
        [self.contentView addSubview:serviceDetsView];
        
        [serviceDetsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(@85);
        }];
        
        [self createMoreServiceButton];
    }
    return self;
}

- (void) createMoreServiceButton
{
    moreServiceButton = [PersonServiceMoreButton buttonWithType:UIButtonTypeCustom];
    [serviceDetsView addSubview:moreServiceButton];
    [moreServiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(serviceDetsView);
        make.right.equalTo(serviceDetsView);
        make.width.mas_equalTo([NSNumber numberWithFloat:kScreenWidth/5]);
    }];
    
    [moreServiceButton setTitle:@"更多" forState:UIControlStateNormal];
    [moreServiceButton setTitleColor:[UIColor commonGrayTextColor] forState:UIControlStateNormal];
    [moreServiceButton.titleLabel setFont:[UIFont font_26]];
    [moreServiceButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [moreServiceButton setImage:[UIImage imageNamed:@"icon_user_more"] forState:UIControlStateNormal];
    [moreServiceButton addTarget:self action:@selector(moreServiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) moreServiceButtonClicked:(id) sender
{
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"我的－更多"];
    [HMViewControllerManager createViewControllerWithControllerName:@"PersonServicesStartViewController" ControllerObject:[NSNumber numberWithInteger:0]];
}

- (void) createUserServiceDets:(NSDictionary*) dicService
{
    NSArray* serviceDets = [dicService objectForKey:@"serviceDets"];
    NSArray* subviews = [serviceDetsView subviews];
    for (UIView* subview in subviews)
    {
        if (![subview isKindOfClass:[PersonSpaceServiceDetCell class]])
        {
            continue;
        }
        [subview removeFromSuperview];
    }
    
    CGFloat cellWidth = self.contentView.width/5;
    NSInteger maxCount = 4;
    if (maxCount > serviceDets.count)
    {
        maxCount = serviceDets.count;
    }
    
    for (NSInteger index = 0; index < maxCount; ++index)
    {
        CGRect rtCell = CGRectMake(cellWidth * index, 0, cellWidth, serviceDetsView.height);
        PersonSpaceServiceDetCell* cell = [[PersonSpaceServiceDetCell alloc]initWithFrame:rtCell];
        [serviceDetsView addSubview:cell];
        
        [cell setServiceDet:serviceDets[index]];
    }
}
@end


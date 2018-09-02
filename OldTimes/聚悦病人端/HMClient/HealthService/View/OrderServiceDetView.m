//
//  OrderServiceDetView.m
//  HMClient
//
//  Created by yinquan on 16/11/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OrderServiceDetView.h"
#import "ServiceInfo.h"

@interface UserServiceDet (ServiceDetValid)

- (BOOL) serviceDetIsValid;

@end

@implementation UserServiceDet (ServiceDetValid)

- (BOOL) serviceDetIsValid
{
    BOOL isValid = NO;
    
    if (self.status != 2) {
        return isValid;
    }
    
    if (self.maxNum == 0) {
        isValid = YES;
        return isValid;
    }
    isValid = (self.remainNum > 0);
    
    return isValid;
}

@end

@interface OrderServiceDetRemainView : UIView

@property (nonatomic, readonly) UILabel* remainHeaderLable;
@property (nonatomic, readonly) UILabel* remainNumLable;
@property (nonatomic, readonly) UILabel* remainTailLable;

@end


@implementation OrderServiceDetRemainView

- (id) init
{
    self = [super init];
    if (self) {
        _remainHeaderLable = [[UILabel alloc] init];
        [self addSubview:self.remainHeaderLable];
        [self.remainHeaderLable setFont:[UIFont systemFontOfSize:14]];
        [self.remainHeaderLable setTextColor:[UIColor commonDarkGrayTextColor]];
        [self.remainHeaderLable setText:@"您还剩余"];
        
        _remainNumLable = [[UILabel alloc] init];
        [self addSubview:self.remainNumLable];
        [self.remainNumLable setFont:[UIFont systemFontOfSize:14]];
        [self.remainNumLable setTextColor:[UIColor commonRedColor]];
        
        _remainTailLable = [[UILabel alloc] init];
        [self addSubview:self.remainTailLable];
        [self.remainTailLable setFont:[UIFont systemFontOfSize:14]];
        [self.remainTailLable setTextColor:[UIColor commonDarkGrayTextColor]];
        [self.remainTailLable setText:@"次服务机会。"];
        
        [self.remainHeaderLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.and.bottom.equalTo(self);
        }];
        [self.remainNumLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.remainHeaderLable.mas_right);
            make.top.and.bottom.equalTo(self);
        }];
        [self.remainTailLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.remainNumLable.mas_right);
            make.top.and.bottom.equalTo(self);
            make.right.equalTo(self);
        }];
    
    }
    return self;
}

- (void) setRemainNum:(NSInteger) remainNum
{
    [self.remainNumLable setText:[NSString stringWithFormat:@"%ld", remainNum]];
}
@end

@interface OrderServiceDetView ()

@property (nonatomic, readonly) UILabel* durationLable;
@property (nonatomic, readonly) UIView* remainView;

@end

@implementation OrderServiceDetView

- (id) init
{
    self = [super init];
    if (self) {
        _durationLable = [[UILabel alloc]init];
        [self addSubview:self.durationLable];
        [self.durationLable setFont:[UIFont systemFontOfSize:14]];
        [self.durationLable setTextColor:[UIColor commonDarkGrayTextColor]];
        
        [self.durationLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.top.equalTo(self).with.offset(17);
            make.right.lessThanOrEqualTo(self).with.offset(-12.5);
        }];
    
        
    }
    return self;
}

- (void) setServiceDet:(UserServiceDet*) serviceDet
{
    if (!serviceDet.beginTime || !serviceDet.endTime || serviceDet.beginTime.length == 0 || serviceDet.endTime.length == 0) {
        [self.durationLable setHidden:YES];
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* beginDate = [formatter dateFromString:serviceDet.beginTime];
    NSDate* endDate = [formatter dateFromString:serviceDet.endTime];
    
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString* beginString = [formatter stringFromDate:beginDate];
    NSString* endString = [formatter stringFromDate:endDate];
    
    NSString* duartionString = [NSString stringWithFormat:@"服务期限:%@~%@", beginString, endString];
    [self.durationLable setText:duartionString];
    
    if (serviceDet.maxNum == 0) {
//        [self.remainView setRemainNum:serviceDet.remainNum];
        UILabel* remainLable = [[UILabel alloc]init];
        _remainView = remainLable;
        
        [self addSubview:self.remainView];
        [self.remainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.top.equalTo(self.durationLable.mas_bottom).with.offset(3);
        }];
        
        [remainLable setFont:[UIFont systemFontOfSize:14]];
        [remainLable setTextColor:[UIColor commonDarkGrayTextColor]];
        [remainLable setText:@""];
    }
    else
    {
        OrderServiceDetRemainView* remainView = [[OrderServiceDetRemainView alloc]init];
        _remainView = remainView;
        [self addSubview:self.remainView];
        [self.remainView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(12.5);
            make.top.equalTo(self.durationLable.mas_bottom).with.offset(3);
        }];
        [remainView setRemainNum:serviceDet.remainNum];
    }
    if ([serviceDet serviceDetIsValid]) {
        UILabel* servieLable = [[UILabel alloc]init];
        [self addSubview:servieLable];
        [servieLable setFont:[UIFont systemFontOfSize:14]];
        [servieLable setTextColor:[UIColor commonDarkGrayTextColor]];
        [servieLable setText:@"可选择以下方式预约或咨询"];
        
        [servieLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.remainView.mas_right);
            make.top.equalTo(self.remainView);
            make.right.lessThanOrEqualTo(self).with.offset(-12.5);
        }];
    }
}
@end

@implementation OrderPackageServiceDetView

- (void) setServiceDet:(UserServiceDet*) serviceDet
{
    [super setServiceDet:serviceDet];
}

@end

@interface OrderValueAddedServiceDetView ()

@property (nonatomic, readonly) NSInteger upId;
@end

@implementation OrderValueAddedServiceDetView

- (void) setServiceDet:(UserServiceDet*) serviceDet
{
    [super setServiceDet:serviceDet];
    _upId = serviceDet.upId;
    
    if (![serviceDet serviceDetIsValid]) {
        UIButton* orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:orderButton];
        [orderButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [orderButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [orderButton setTitle:@"点我重新订购此服务>" forState:UIControlStateNormal];
        
        [orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.remainView.mas_right);
            make.centerY.equalTo(self.remainView);
        }];
        [orderButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

}

- (void) orderButtonClicked:(id) sender
{
    //跳转到服务订购界面
    ServiceInfo* serviceInfo = [[ServiceInfo alloc]init];
    [serviceInfo setUpId:self.upId];
//    [HMViewControllerManager createViewControllerWithControllerName:@"ServiceDetailStartViewController" FromControllerId:nil ControllerObject:serviceInfo];
    [HMViewControllerManager createViewControllerWithControllerName:@"SecondEditionServiceDetailViewController" ControllerObject:[NSString stringWithFormat:@"%ld", serviceInfo.upId]];
}

@end

//
//  ServiceInfo.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceInfo : NSObject
{
    
}
- (BOOL) isGoods;

@property (nonatomic, assign) NSInteger userServiceId;
@property (nonatomic, assign) NSInteger serviceId;
@property (nonatomic, assign) NSInteger upId;              //上架ID
@property (nonatomic, assign) NSInteger grade;
//@property (nonatomic, assign) NSInteger PRODUCT_NUM;        //服务剩余数

@property (nonatomic, retain) NSString* provider;            //提供者名称
@property (nonatomic, retain) NSString* orgName;
@property (nonatomic, retain) NSString* productName;
@property (nonatomic, retain) NSString* billWayName;      //服务方式名称
@property (nonatomic, assign) NSInteger billWayNum;       //服务方式数量
@property (nonatomic, retain) NSString* desc;

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString* imgUrl;

@property (nonatomic, assign) float salePrice;  //售价
@property (nonatomic, assign) float marketPrice;  //原价

@property (nonatomic, assign) NSInteger classify;   //服务类型 0单项商品1单项服务2套餐3基础服务4试用服务5增值服务
@property (nonatomic, assign) NSInteger subClassify; //subClassify 0表示是商品 1服务

@end

@interface ServiceDetailOption : NSObject
{
    
}

@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger upDetId;
@property (nonatomic, assign) NSInteger upId;
@property (nonatomic, retain) NSString* productName;
@property (nonatomic, assign) NSInteger billWayNum;
@property (nonatomic, retain) NSString* billWayName;
@property (nonatomic, assign) float salePrice;
@end

@interface ServiceDetailData : NSObject
{
    
}

@property (nonatomic, retain) NSString* comboName;
@property (nonatomic, retain) NSString* mainProviderName;
@property (nonatomic, retain) NSString* mainProviderDes;

@property (nonatomic, retain) NSString* comboBillWayName;       //套餐有效单位
@property (nonatomic, assign) NSInteger comboBillWayNum;        //套餐有效数量
@property (nonatomic, assign) float salePrice;
@property (nonatomic, assign) float rebate;                     //折扣率
@property (nonatomic, assign) float markPrice;
@property (nonatomic, retain) NSString* img;

@property (nonatomic, retain) NSArray* isMustYes;
@property (nonatomic, retain) NSArray* isMustNo;

@property (nonatomic, retain) NSString* productDes;
@end

@interface ServicePayWay : NSObject
{
    
}

@property (nonatomic, assign) NSInteger payWayId;
@property (nonatomic, retain) NSString* payWayCode;
@property (nonatomic, retain) NSString* payWayName;
@end

@interface ServiceDetail : NSObject
{
    
}

@property (nonatomic, retain) ServiceDetailData* data;

@property (nonatomic, assign) NSInteger UP_ID;              //上架ID
@property (nonatomic, retain) NSString* comboName;
@property (nonatomic, retain) NSString* mainProviderName;
@property (nonatomic, retain) NSString* mainProviderDes;
@property (nonatomic, retain) NSString* comboBillWayName;       //套餐有效单位
@property (nonatomic, assign) NSInteger comboBillWayNum;        //套餐有效数量
@property (nonatomic, assign) float salePrice;
@property (nonatomic, assign) float rebate;                     //折扣率
@property (nonatomic, assign) float markPrice;
@property (nonatomic, retain) NSString* img;

@property (nonatomic, retain) NSArray* isMustYes;
@property (nonatomic, retain) NSArray* isMustNo;

@property (nonatomic, retain) NSString* productDes;

@property (nonatomic, assign) NSInteger service_status;
@property (nonatomic, retain) NSArray* selectMust;
@property (nonatomic, retain) NSArray* payWayList;  //支付方式列表
@property (nonatomic, assign) NSInteger grade;

@end

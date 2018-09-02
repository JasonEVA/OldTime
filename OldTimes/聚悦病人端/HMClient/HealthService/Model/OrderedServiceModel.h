//
//  OrderedServiceModel.h
//  JYHMUser
//
//  Created by yinquan on 16/11/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderedServiceModel : NSObject

@property (nonatomic, assign) NSInteger upId;
@property (nonatomic, retain) NSString* productName;
@property (nonatomic, assign) NSInteger classify;   //服务类型 2套餐 3基础服务 4试用 5增值服务
@property (nonatomic, retain) NSString* provider;
@property (nonatomic, retain) NSString* orgName;
@property (nonatomic, retain) NSString* imageUrl;

@property (nonatomic, assign) NSInteger provideTeamId;
@property (nonatomic, retain) NSString* provideTeamName;

@property (nonatomic, assign) NSInteger status;     //状态1待支付 2服务中 3已结束 4已取消
@property (nonatomic, retain) NSString* beginTime;
@property (nonatomic, retain) NSString* orderTime;
@property (nonatomic, retain) NSString* endTime;

@property (nonatomic, retain) NSArray* dets;

//是否是商品
- (BOOL) isGoods;

//是否时基础服务
- (BOOL) isBasicService;
@end

@interface UserServiceDet : NSObject

@property (nonatomic, retain) NSString* beginTime;
@property (nonatomic, retain) NSString* endTime;

@property (nonatomic, assign) NSInteger upId;
@property (nonatomic, assign) NSInteger serviceDetId;
@property (nonatomic, retain) NSString* childProductName;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, assign) NSInteger remainNum;
@property (nonatomic, assign) NSInteger classify;
@property (nonatomic, assign) NSInteger subClassify;
@property (nonatomic, retain) NSString* subServicePhone;
@property (nonatomic, retain) NSString* desc;

@property (nonatomic, assign) NSInteger status;
@end

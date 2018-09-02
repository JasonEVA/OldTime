//
//  IMPatientContactExtensionModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/1/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//  IM医患聊天扩展model

#import <Foundation/Foundation.h>

@interface IMPatientContactExtensionModel : NSObject

@property (nonatomic, copy)  NSString  *ver; // 扩展版本
@property (nonatomic, copy)  NSString  *pId; // 患者UserID
@property (nonatomic, copy)  NSString  *pName; // 患者姓名
@property (nonatomic, assign)  NSInteger  isPay; // 是否付费，0未付费，1付费
@property (nonatomic, assign)  NSInteger  canChat; // 是否可以聊天，0不可聊天，1可聊天
@property (nonatomic, assign)  NSInteger  userType; // (个人用户:0,集团用户:1)
@property (nonatomic, assign)  NSInteger  classify; // 服务种类  商品分类(0单项商品1单项服务2套餐3基础服务4试用服务5增值服务)
@property (nonatomic, assign)  NSInteger  blocRank; //  集团用户等级(默认 0) 0 无等级 1 普通 , 2 中层 , 3 VIP
@property (nonatomic, assign)  NSInteger  isBlocService; // 是否是集团服务 1是，0否

- (instancetype)initWithExtensionJsonString:(NSString *)jsonString;
@end

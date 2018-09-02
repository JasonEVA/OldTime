//
//  NewSiteMessageDrugModel.h
//  HMClient
//
//  Created by jasonwang on 2017/1/20.
//  Copyright © 2017年 YinQ. All rights reserved.
//  站内信 药品model

#import <Foundation/Foundation.h>

@interface NewSiteMessageDrugModel : NSObject
@property (nonatomic, copy) NSString *drugName;     //药品名称
@property (nonatomic, copy) NSString *recipeDetId;     //
@property (nonatomic, copy) NSString *drugId;     //药品id
@property (nonatomic, copy) NSString *drugUsageName;     //药品用法

@end

//{"drugName":"阿替洛尔","recipeDetId":"CF_FADCECA0870F420788617EB92E81DC51","drugId":"210","drugUsageName":"用法：口服 每日两次,12.5mg"}

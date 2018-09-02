//
//  NewSiteMessageMedicationRemindModel.h
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  用药提醒model

#import <Foundation/Foundation.h>
#import "NewSiteMessageDrugModel.h"

@interface NewSiteMessageMedicationRemindModel : NSObject
@property (nonatomic, copy) NSArray<NewSiteMessageDrugModel *> *drugList;      //药列表
@property (nonatomic, copy) NSString *msgTitle;         //标题
@property (nonatomic, copy) NSString *msg;              //内容
@property (nonatomic, copy) NSString *type;  //类型

@end

//{"msgTitle":"用药提醒","drugList":[{"drugName":"阿替洛尔","recipeDetId":"CF_FADCECA0870F420788617EB92E81DC51","drugId":"210","drugUsageName":"用法：口服 每日两次,12.5mg"}],"type":"drugPush","msg":"亲，请坚持用药身体棒棒哦"}

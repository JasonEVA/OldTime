//
//  HMConsultingRecordsModel.h
//  HMClient
//
//  Created by jasonwang on 2017/4/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//  我的-咨询记录model

#import <Foundation/Foundation.h>

@interface HMConsultingRecordsModel : NSObject
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic) long long cancelTime;
@property (nonatomic) long long beginTime;
@property (nonatomic, copy) NSString *imGroupId;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *status;          // status = 2 为当前服务
@property (nonatomic) long long userServiceId;
@end

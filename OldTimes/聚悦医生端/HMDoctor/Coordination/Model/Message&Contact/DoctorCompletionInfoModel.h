//
//  DoctorCompletionInfoModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//  医生详细信息model

#import <Foundation/Foundation.h>

@interface DoctorCompletionInfoModel : NSObject

@property (nonatomic, strong)  NSString  *imgUrl;
@property (nonatomic, strong)  NSString  *orgName;
@property (nonatomic)  NSInteger  staffId;
@property (nonatomic, strong)  NSString  *staffName;
@property (nonatomic, strong)  NSString  *staffTypeName;
@property (nonatomic)  NSInteger  userId;

@end

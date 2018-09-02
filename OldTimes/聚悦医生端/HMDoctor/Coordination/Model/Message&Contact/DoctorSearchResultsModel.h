//
//  DoctorSearchResultsModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//  医生搜索结果model

#import <Foundation/Foundation.h>

@class DoctorCompletionInfoModel;
@interface DoctorSearchResultsModel : NSObject

@property (nonatomic)  NSInteger  count; // 条数
@property (nonatomic, copy)  NSArray<DoctorCompletionInfoModel *>  *list; // 医生列表
@end

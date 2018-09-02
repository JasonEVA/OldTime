//
//  NewPatientGroupListInfoModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//  新版病人团队列表model

#import <Foundation/Foundation.h>

@class NewPatientListInfoModel;
@interface NewPatientGroupListInfoModel : NSObject

@property (nonatomic, retain) NSString* teamName;
@property (nonatomic, retain) NSMutableArray <NewPatientListInfoModel *>* users;
@property (nonatomic, assign) BOOL isExpanded;
@property (nonatomic, assign)  NSInteger  teamId; // andrew增加
@property (nonatomic, assign) BOOL isAllSelected; // Jason添加 是否被全选
@property (nonatomic, assign)  NSInteger userCount; // Jason添加 计数
@end

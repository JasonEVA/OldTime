//
//  StaffServiceInfoModel.h
//  HMDoctor
//
//  Created by kylehe on 16/6/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  团队创建时间和已经服务的数量

#import <Foundation/Foundation.h>

@interface StaffServiceInfoModel : NSObject

@property(nonatomic, copy) NSString  *createTime; //创建时长

@property(nonatomic, copy) NSNumber  *serviceNum; // 当前服务数量

@property(nonatomic, copy) NSNumber  *allNum;   //所有服务数量



@end

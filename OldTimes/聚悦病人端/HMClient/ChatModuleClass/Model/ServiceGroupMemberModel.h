//
//  ServiceGroupMemberModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//  服务群单成员model

#import <Foundation/Foundation.h>

@interface ServiceGroupMemberModel : NSObject

@property (nonatomic, assign)  NSInteger  depId;
@property (nonatomic, copy)  NSString  *depName;
@property (nonatomic, copy)  NSString  *imgUrl;
@property (nonatomic, copy)  NSString  *opTime;
@property (nonatomic, assign)  NSInteger  opeator;
@property (nonatomic, assign)  NSInteger  orgId;
@property (nonatomic, copy)  NSString  *orgName;
@property (nonatomic, assign)  NSInteger  staffId;
@property (nonatomic, copy)  NSString  *staffName;
@property (nonatomic, copy)  NSString  *staffTypeName;
@property (nonatomic, assign)  NSInteger  teamDetId;
@property (nonatomic, assign)  NSInteger  teamId;
@property (nonatomic, copy)  NSString  *teamStaffTypeCode;
@property (nonatomic, copy)  NSString  *teamStaffTypeName;
@property (nonatomic, assign)  NSInteger  userId;

@property (nonatomic, assign)  BOOL  selected; // <##>
@end

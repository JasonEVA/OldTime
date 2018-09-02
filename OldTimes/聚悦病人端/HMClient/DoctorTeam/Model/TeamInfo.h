//
//  TeamInfo.h
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class StaffInfo;
@interface TeamInfo : NSObject
{
    
}

@property (nonatomic, assign) NSInteger teamId;
@property (nonatomic, retain) NSString* teamName;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, retain) NSString* teamStaffName;
@property (nonatomic, retain) NSString* depName;
@property (nonatomic, retain) NSString* staffTypeName;
@property (nonatomic, assign) NSInteger teamStaffId;
@property (nonatomic, retain) NSString* orgName;
@property (nonatomic, assign) NSInteger orgId;
@property (nonatomic, retain) NSString* teamDesc;

@property (nonatomic, assign) NSInteger teamControllerFlag; //1 － 用户需要升级服务

@end

@interface TeamDetail : TeamInfo

@property (nonatomic, retain) NSArray<StaffInfo *>* orgTeamDet;
@property (nonatomic, retain) NSArray* services;
@end

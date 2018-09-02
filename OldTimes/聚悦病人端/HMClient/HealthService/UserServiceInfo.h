//
//  UserServiceInfo.h
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserServiceInfo : NSObject
{
    
}

@property (nonatomic, assign) NSInteger upId;
@property (nonatomic, assign) NSInteger userServiceId;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString* orgName;
@property (nonatomic, retain) NSString* serviceName;
@property (nonatomic, retain) NSString* createTime;
@property (nonatomic, retain) NSString* imageUrl;
@property (nonatomic, retain) NSString* providerName;
@property (nonatomic, assign) NSInteger billWayNum;
@property (nonatomic, retain) NSString* billWayName;

@property (nonatomic, retain) NSString* beginTime;
@property (nonatomic, retain) NSString* endTime;

@property (nonatomic, assign) NSInteger classify;

@property (nonatomic, retain) NSArray* dets;

@property (nonatomic, retain) NSString* provideTeamId;      //服务提供团队Id
@property (nonatomic, retain) NSString* provideTeamName;    //服务提供团队名称

@end

@interface UserServiceDetInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* childProductName;
@property (nonatomic, retain) NSString* billWayName;
@property (nonatomic, assign) NSInteger billWayNum;

@property (nonatomic, assign) NSInteger maxNum;
@property (nonatomic, assign) NSInteger remainNum;
@property (nonatomic, retain) NSString* imgUrl;

@end

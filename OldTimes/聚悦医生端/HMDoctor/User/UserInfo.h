//
//  UserInfo.h
//  HealthManagerDoctorDemo
//
//  Created by yinqaun on 16/1/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

//#import "ModelObject.h"

@interface UserInfo : NSObject

@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* nickName;
@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger depId;
@property (nonatomic, assign) NSInteger orgId;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, retain) NSString* logonAcct;


@end

@interface StaffInfo : NSObject

@property (nonatomic, assign) NSInteger staffId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger orgId;
@property (nonatomic, retain) NSString* depId;
@property (nonatomic, assign) NSInteger staffTypeId;
@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* staffTypeName;
@property (nonatomic, retain) NSString* depName;
@property (nonatomic, retain) NSString* depPhone;
@property (nonatomic, retain) NSString* orgName;
@property (nonatomic, retain) NSString* staffIcon;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, retain) NSString* gootAt;
@property (nonatomic, retain) NSString* staffDesc;

@property (nonatomic, retain) NSString* fans;
@property (nonatomic, retain) NSString* isFavor;
@property (nonatomic, retain) NSString* folk;
@property (nonatomic, retain) NSString* moneyBag;

@end

@interface UserInfoHelper : NSObject
{
    
}

@property (nonatomic, readonly) UserInfo* currentUserInfo;
@property (nonatomic, readonly) StaffInfo* currentStaffInfo;
@property (nonatomic, readonly) NSString* staffRole;
@property (nonatomic, retain) NSString* loginAcct;

@property(nonatomic, assign) BOOL  isBigFont;

+ (UserInfoHelper*) defaultHelper;

- (void) userlogout;
- (void) saveUserInfo:(UserInfo*) user;
- (void) saveStaffInfo:(StaffInfo*) staff;
- (void) setStaffRole:(NSString*) role;

+ (NSString*) userDir;
@end

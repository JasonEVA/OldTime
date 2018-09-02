//
//  UserInfo.h
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
{
    
}

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* nickName;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, retain) NSString* img;
@property (nonatomic, retain) NSString* mobile;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* birth;
@property (nonatomic, retain) NSString* idCard;

@property (nonatomic, assign) float userHeight;
@property (nonatomic, assign) float userWeight;

@property (nonatomic, retain) NSString* logonAcct;  //登录账号

//1未认证 2身份证认证 3医保卡认证 4医生资格证认
@property (nonatomic, copy) NSString *authenticationType;

@property (nonatomic, retain) NSArray* userIlls;
@property (nonatomic, copy) NSString *IMUid;        //病人IM群的Uid   Jason添加
@property (nonatomic, copy) NSString *teamId;       //病人所在团队Id   Jason添加
@property (nonatomic, copy) NSString *blocName;     // 集团用户标示
@property (nonatomic, assign) NSInteger blocId;     // 集团用户标示Id

@end

@interface StaffInfo : NSObject

@property (nonatomic, assign) NSInteger staffId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger orgId;
@property (nonatomic, assign) NSInteger depId;
@property (nonatomic, assign) NSInteger staffTypeId;
@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* staffTypeName;
@property (nonatomic, retain) NSString* teamStaffTypeName;

@property (nonatomic, retain) NSString* depName;
@property (nonatomic, retain) NSString* orgName;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, retain) NSString* staffIcon;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, retain) NSString* gootAt;

@end

typedef void(^UserInfoHelperBlock)(UserInfo* currentUserInfo , NSString *errorContent);
@interface UserInfoHelper : NSObject
{
    
}

@property (nonatomic, strong) UserInfo* currentUserInfo;
@property (nonatomic, retain) NSString* loginAcct;
@property (nonatomic, assign) BOOL  isBigFont;

@property (nonatomic, strong) NSString* lastSignedDate; //最后签到日期
@property (nonatomic, strong) NSString* showBrithDay;   //显示生日提示的日期

+ (UserInfoHelper*) defaultHelper;
+ (BOOL) needLogin;

- (void) saveUserInfo:(UserInfo*) userInfo;

- (void)getIMGroupUid:(UserInfoHelperBlock)block;  //获取当前账号下最新IMGroup的UID
- (void) userlogout;

- (BOOL) todayHasBeenSigned;
- (BOOL) todayHasShownBrithday;
@end

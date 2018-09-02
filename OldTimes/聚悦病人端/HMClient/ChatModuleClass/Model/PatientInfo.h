//
//  PatientInfo.h
//  HMDoctor
//
//  Created by yinquan on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PatientInfo : NSObject
{
    
}

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* imgUrl;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, retain) NSString* illName;
@property (nonatomic, retain) NSString* testResulId; //从预警传过来的，是UserAlertInfo的参数
@property (nonatomic, assign)  NSInteger  teamId; // jsaon增加
@property (nonatomic, retain) NSDictionary* userTestDatas;

@end

@interface PatientGroupInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* teamName;
@property (nonatomic, retain) NSArray<PatientInfo *>* users;

@property (nonatomic, assign)  NSInteger  teamId; // andrew增加
@end

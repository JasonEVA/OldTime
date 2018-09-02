//
//  AppointmentInfo.h
//  HMClient
//
//  Created by yinqaun on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppointmentInfo : NSObject
{
    
}
@property (nonatomic, assign) NSInteger appointId;
@property (nonatomic, assign) NSInteger agreeUserId;
@property (nonatomic, retain) NSString*  appointTime;
@property (nonatomic, retain) NSString* appointAddr;
@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, assign) NSInteger staffId;
@property (nonatomic, retain) NSString* noticeCon;

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger applyType;
@property (nonatomic, retain) NSString* applyTypeStr;
@property (nonatomic, retain) NSString* doWayStr;
@property (nonatomic, assign) NSInteger doWay;

@property (nonatomic, retain) NSString* orgName;
@property (nonatomic, retain) NSString* orgShortName;
@property (nonatomic, retain) NSString* depName;
@property (nonatomic, retain) NSString* staffTypeName;

- (NSString*) statusString;

- (NSString*) staffExpendString;

@end

@interface AppointmentDetail : AppointmentInfo
{

}

@property (nonatomic, retain) NSString* createTime;
@property (nonatomic, retain) NSString* symptomDesc;
@property (nonatomic, retain) NSArray* images;

@end

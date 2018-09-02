//
//  SurveyRecord.h
//  HMClient
//
//  Created by lkl on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyRecord : NSObject

@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *mainIll;

@property (nonatomic, retain) NSString* createTime;

@property (nonatomic, retain) NSString* fillTime;
@property (nonatomic, retain) NSString* surveyMoudleName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, retain) NSString* surveyId;
@property (nonatomic, retain) NSString* surveyMoudleId;
@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger healthyId;

@end

@interface SurveryMoudle : NSObject

@property (nonatomic, retain) NSString* illName;
@property (nonatomic, retain) NSString* surveyMoudleName;
@property (nonatomic, assign) NSInteger surveyMoudleId;

@end

@interface SurveryMoudleGroup : NSObject

@property (nonatomic, retain) NSString* illName;
@property (nonatomic, retain) NSArray* surveyMoudles;
@end

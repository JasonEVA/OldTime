//
//  SurveyRecord.h
//  HMClient
//
//  Created by lkl on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyRecord : NSObject

@property (nonatomic, retain) NSString* fillTime;

@property (nonatomic, retain) NSString* surveyMoudleName;
@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* surveyId;
@property (nonatomic, retain) NSString* surveyMoudleId;
@property (nonatomic, assign) NSInteger status;

@end

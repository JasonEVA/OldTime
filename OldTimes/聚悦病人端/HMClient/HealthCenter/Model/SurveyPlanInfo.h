//
//  SurveyPlanInfo.h
//  HMClient
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SurveyPlanInfo : NSObject

@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* planTime;
@property (nonatomic, retain) NSString* planRate;
@property (nonatomic, retain) NSString* planName;
@property (nonatomic, retain) NSString* periodTime;


@end

@interface DetectHealthPlanInfo : NSObject

@property (nonatomic, retain) NSString* staffName;
@property (nonatomic, retain) NSString* planTime;
@property (nonatomic, retain) NSString* planRate;
@property (nonatomic, retain) NSString* planName;
@property (nonatomic, retain) NSString* periodTime;


@end
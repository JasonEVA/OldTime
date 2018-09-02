//
//  HMExercisePKModel.h
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//  步数PK model

#import <Foundation/Foundation.h>

@interface HMExercisePKModel : NSObject
@property (nonatomic) long long favourCount;
@property (nonatomic) long long favoured;
@property (nonatomic) long long stepCount;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *userExerciseId;
@property (nonatomic) long long userId;
@property (nonatomic, copy) NSString *userName;
@end

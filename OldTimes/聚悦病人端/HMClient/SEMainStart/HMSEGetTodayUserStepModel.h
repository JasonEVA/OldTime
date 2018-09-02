//
//  HMSEGetTodayUserStepModel.h
//  HMClient
//
//  Created by lkl on 2017/10/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMSEGetTodayUserStepModel : NSObject

@property (nonatomic, copy) NSString *exerciseDate;
@property (nonatomic, assign) NSInteger stepCount;
@property (nonatomic, copy) NSString *userExerciseId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *updateTime;
@end

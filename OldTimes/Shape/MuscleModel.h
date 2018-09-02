//
//  MuscleModel.h
//  Shape
//
//  Created by Andrew Shen on 15/11/6.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Muscle;
@interface MuscleModel : NSObject
@property (nonatomic, copy) NSString *muscleName;
@property (nonatomic, strong) NSNumber *trainingTimes;
@property (nonatomic, strong) NSDate *lastTrainingDate;
@property (nonatomic, strong) NSNumber *calories;
@property (nonatomic, strong) NSNumber *score;

- (instancetype)initWithEntity:(Muscle *)model;

- (void)covertToEntity:(Muscle *)model;
@end

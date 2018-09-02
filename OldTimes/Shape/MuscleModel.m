//
//  MuscleModel.m
//  Shape
//
//  Created by Andrew Shen on 15/11/6.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MuscleModel.h"
#import "Muscle.h"

@implementation MuscleModel

- (instancetype)initWithEntity:(Muscle *)model
{
    self = [super init];
    if (self) {
        // 从entity初始化
        self.muscleName = model.muscleName;
        self.trainingTimes = model.trainingTimes;
        self.lastTrainingDate = model.lastTrainingDate;
        self.calories = model.calories;
        self.score = model.score;
    }
    return self;
}

- (void)covertToEntity:(Muscle *)model {
    model.muscleName = self.muscleName;
    model.trainingTimes = self.trainingTimes;
    model.lastTrainingDate = self.lastTrainingDate;
    model.calories = self.calories;
    model.score = self.score;

}
@end

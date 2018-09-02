//
//  Muscle+CoreDataProperties.h
//  Shape
//
//  Created by Andrew Shen on 15/11/6.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Muscle.h"

NS_ASSUME_NONNULL_BEGIN

@interface Muscle (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *calories;
@property (nullable, nonatomic, retain) NSDate *lastTrainingDate;
@property (nullable, nonatomic, retain) NSString *muscleName;
@property (nullable, nonatomic, retain) NSNumber *score;
@property (nullable, nonatomic, retain) NSNumber *trainingTimes;

@end

NS_ASSUME_NONNULL_END

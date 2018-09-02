//
//  Weight+CoreDataProperties.h
//  Shape
//
//  Created by Andrew Shen on 15/11/6.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Weight.h"

NS_ASSUME_NONNULL_BEGIN

@interface Weight (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *timeStamp;
@property (nullable, nonatomic, retain) NSNumber *weight;

@end

NS_ASSUME_NONNULL_END

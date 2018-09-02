//
//  TeamClassModel.h
//  Shape
//
//  Created by Andrew Shen on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  团课model

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    state_available,
    state_booked,
    state_full,
} TeamClassState;

@interface TeamClassModel : NSObject
@property (nonatomic, copy)  NSString  *startTime; // <##>
@property (nonatomic, copy)  NSString  *endTime; // <##>
@property (nonatomic, copy)  NSString  *className; // <##>
@property (nonatomic)  TeamClassState  classState; // <##>
@property (nonatomic, copy)  NSString  *classStateName; // <##>


- (instancetype)initWithTestState:(TeamClassState)state name:(NSString *)name startTime:(NSString *)startTime endTime:(NSString *)endTime;
@end

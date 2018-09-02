//
//  TeamClassModel.m
//  Shape
//
//  Created by Andrew Shen on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TeamClassModel.h"

@implementation TeamClassModel

- (NSString *)classStateName {
    switch (self.classState) {
        case state_available:
            return @"可预约";
            break;
            
        case state_booked:
            return @"已预约";
            break;
            
        case state_full:
            return @"满员";
            break;

        default:
            return @"可预约";
            break;
    }
}

// 假数据
- (instancetype)initWithTestState:(TeamClassState)state name:(NSString *)name startTime:(NSString *)startTime endTime:(NSString *)endTime {
    if (self = [super init]) {
        self.startTime = startTime; // <##>
        self.endTime = endTime; // <##>
        self.className = name; // <##>
        self.classState = state; // <##>
    }
    return self;
}
@end

//
//  WeightModel.m
//  Shape
//
//  Created by Andrew Shen on 15/11/6.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "WeightModel.h"
#import "Weight.h"

@implementation WeightModel
- (instancetype)initWithEntity:(Weight *)model
{
    self = [super init];
    if (self) {
        // 从entity初始化
        self.timeStamp = model.timeStamp;
        self.weight = model.weight;
    }
    return self;
}

- (void)covertToEntity:(Weight *)model {
    model.timeStamp = self.timeStamp;
    model.weight = self.weight;
}

@end

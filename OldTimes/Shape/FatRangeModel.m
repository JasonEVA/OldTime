//
//  FatRangeModel.m
//  Shape
//
//  Created by Andrew Shen on 15/11/6.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "FatRangeModel.h"
#import "FatRange.h"

@implementation FatRangeModel
- (instancetype)initWithEntity:(FatRange *)model
{
    self = [super init];
    if (self) {
        // 从entity初始化
        self.fatRange = model.fatRange;
    }
    return self;
}

- (void)covertToEntity:(FatRange *)model {
    model.fatRange = self.fatRange;
}

@end

//
//  FatRangeModel.h
//  Shape
//
//  Created by Andrew Shen on 15/11/6.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 体脂率model

#import <Foundation/Foundation.h>
@class FatRange;

@interface FatRangeModel : NSObject
@property (nonatomic, copy) NSString *fatRange;

- (instancetype)initWithEntity:(FatRange *)model;
- (void)covertToEntity:(FatRange *)model;

@end

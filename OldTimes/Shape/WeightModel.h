//
//  WeightModel.h
//  Shape
//
//  Created by Andrew Shen on 15/11/6.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
// 体重model

#import <Foundation/Foundation.h>
@class Weight;

@interface WeightModel : NSObject

@property (nonatomic, strong) NSDate *timeStamp;
@property (nonatomic, strong) NSNumber *weight;

- (instancetype)initWithEntity:(Weight *)model;

- (void)covertToEntity:(Weight *)model;
@end

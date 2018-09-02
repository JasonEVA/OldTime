//
//  NutritionDietEstimateDataInfo.h
//  HMClient
//
//  Created by lkl on 2017/8/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NutritionFoodContentModel : NSObject

@property (nonatomic, copy) NSString *foodImg;
@property (nonatomic, copy) NSString *foodDesc;
@end

@interface NutritionDietEstimateDataModel : NSObject

@property (nonatomic, copy) NSString *foodName;
@property (nonatomic, strong) NSArray *foodContent;

@end

@interface NutritionDietEstimateDataInfo : NSObject

+ (NSArray *)getFoodsInfo;

@end

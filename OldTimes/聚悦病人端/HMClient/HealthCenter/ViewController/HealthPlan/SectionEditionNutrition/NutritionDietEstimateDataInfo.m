//
//  NutritionDietEstimateDataInfo.m
//  HMClient
//
//  Created by lkl on 2017/8/18.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NutritionDietEstimateDataInfo.h"

@implementation NutritionFoodContentModel

@end

@implementation NutritionDietEstimateDataModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"foodContent" : @"NutritionFoodContentModel",
             };
}

@end

@implementation NutritionDietEstimateDataInfo

+ (NSArray *)getFoodsInfo
{
    NSArray *array = @[
                       
                       //菜肴
                       @{
                           @"foodName":@"菜肴",
                           @"foodContent":@[
                                   @{
                                       @"foodImg":@"img_diet_1",
                                       @"foodDesc":@"一碟荤菜约100克",
                                       },
                                   
                                   @{
                                       @"foodImg":@"img_diet_2",
                                       @"foodDesc":@"一碟半荤约150克",
                                       },
                                   
                                   @{
                                       @"foodImg":@"img_diet_3",
                                       @"foodDesc":@"一碗素菜约150克",
                                       },
                                   
                                   @{
                                       @"foodImg":@"img_diet_4",
                                       @"foodDesc":@"一碗汤约150克",
                                       },
                                   
                                   @{
                                       @"foodImg":@"img_diet_5",
                                       @"foodDesc":@"一顿饭约700克",
                                       },
                                   
                                   ],
                           },
                       
                       //米饭
                       @{
                           @"foodName":@"米饭",
                           @"foodContent":@[
                                   @{
                                       @"foodImg":@"img_diet_6",
                                       @"foodDesc":@"一碗米饭约200克",
                                       },
                                   
                                   @{
                                       @"foodImg":@"img_diet_7",
                                       @"foodDesc":@"一盘米饭约200克",
                                       },
                                   @{
                                       @"foodImg":@"img_diet_8",
                                       @"foodDesc":@"食堂托盘一格米饭约200克",
                                       },
                                   ],
                           },
                       
                       //面条
                       @{
                           @"foodName":@"面条",
                           @"foodContent":@[
                                   @{
                                       @"foodImg":@"img_diet_9",
                                       @"foodDesc":@"一碗汤面约500克（不含汤）",
                                       },
                                   
                                   @{
                                       @"foodImg":@"img_diet_10",
                                       @"foodDesc":@"一碗炒面约400克",
                                       },
                                   
                                   @{
                                       @"foodImg":@"img_diet_11",
                                       @"foodDesc":@"一盘炒面约400克",
                                       },
                                   ],
                           },
                       
                       //馒头
                       @{
                           @"foodName":@"馒头",
                           @"foodContent":@[
                                   @{
                                       @"foodImg":@"img_diet_12",
                                       @"foodDesc":@"一个馒头约90克",
                                       },
                                   ],
                           },
                       
                       //包子
                       @{
                           @"foodName":@"包子",
                           @"foodContent":@[
                                   @{
                                       @"foodImg":@"img_diet_13",
                                       @"foodDesc":@"一个包子约100克",
                                       },
                                   ],
                           },
                       
                       //面包
                       @{
                           @"foodName":@"面包",
                           @"foodContent":@[
                                   @{
                                       @"foodImg":@"img_diet_14",
                                       @"foodDesc":@"一个面包约50克",
                                       },
                                   ],
                           },
                       
    
                        //麦片
                        @{
                          @"foodName":@"麦片",
                          @"foodContent":@[
                                  @{
                                      @"foodImg":@"img_diet_15",
                                      @"foodDesc":@"一碟麦片（谷物）约30克",
                                      },
                                  
                                  @{
                                      @"foodImg":@"img_diet_16",
                                      @"foodDesc":@"一碟麦片（膨化）约30克",
                                      },
                                  ],
                          },
                    
                    ];
    return array;
}

@end

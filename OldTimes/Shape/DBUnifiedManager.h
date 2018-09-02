//
//  DBUnifiedManager.h
//  Shape
//
//  Created by Andrew Shen on 15/10/30.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  数据库统一管理工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FatRange;
@class Muscle;
@class MuscleModel;
@class Weight;

@interface DBUnifiedManager : NSObject

+ (DBUnifiedManager *)share;
#pragma mark - InterfaceMethod

#pragma mark - Muscle
/**
 *  保存肌肉数据
 *
 *  @param model 肌肉model数据
 */
- (void)saveMuscleData:(MuscleModel *)model;

/**
 *  查询某部分肌肉在某个周期内数据
 *  @param arrayMuscleNames muscleName数组
 *
 *  @param beginDate 起始日期
 *  @param endDate   结束日期
 *
 *  @return 肌肉数据数组
 */
- (NSArray<MuscleModel *> *)fetchMuscleData:(NSArray<NSString *> *)arrayMuscleNames FromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

/**
 *  查询某个周期内肌肉数据
 *
 *  @param beginDate 起始日期
 *  @param endDate   结束日期
 *
 *  @return 所有肌肉实体
 */
- (NSArray<MuscleModel *> *)fetchAllMuscleDataFromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

#pragma mark - Weight

/**
 *  保存体重
 */
- (void)saveWeight:(CGFloat)weight;

- (void)saveWeight:(CGFloat)weight date:(NSDate *)date;

/**
 *  查询体重
 */
- (NSArray *)fetchWeightWithCount:(NSInteger)count;

/**
 *  查询某一个周期内体重数据
 *
 *  @param beginDate 开始时间
 *  @param endDate  结束时间
 *
 *  @return 体重数据
 */
- (NSArray<Weight *> *)fetchWeightDataFromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

#pragma mark - FatRange
/**
 *  保存体脂率
 */
- (void)saveFatRange:(NSString *)fatRange;

/**
 *  查询体脂率
 */
- (FatRange *)fetchFatRange;

#pragma mark - FetchAll
/**
 *  查询某个周期内所有肌肉综合数据
 *
 *  @param beginDate 起始日期
 *  @param endDate   结束日期
 *
 *  @return 所有肌肉数据
 */
- (MuscleModel *)fetchComprehensiveDataFromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;
@end

//
//  DBUnifiedManager.m
//  Shape
//
//  Created by Andrew Shen on 15/10/30.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "DBUnifiedManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DateUtil.h"

#import "Weight.h"
#import "FatRange.h"
#import "Muscle.h"

#import "MuscleModel.h"
#import "FatRangeModel.h"
#import "WeightModel.h"

@implementation DBUnifiedManager

+ (DBUnifiedManager *)share {
    static DBUnifiedManager *DBManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DBManager = [[self alloc] init];
#warning 测试数据
        [DBManager initMuscleData];
    });
    return DBManager;
}
#pragma mark - InterfaceMethod

#pragma mark - Muscle
- (void)saveMuscleData:(MuscleModel *)model {
    Muscle *muscle = [Muscle MR_createEntity];
    [model covertToEntity:muscle];
    [self saveToPersistent];
}

/**
 *  查询某部分肌肉在某个周期内数据
 *  @param arrayMuscleNames muscleName数组
 *
 *  @param beginDate 起始日期
 *  @param endDate   结束日期
 *
 *  @return 肌肉数据数组
 */
- (NSArray<MuscleModel *> *)fetchMuscleData:(NSArray<NSString *> *)arrayMuscleNames FromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"lastTrainingDate BETWEEN {%@,%@} AND muscleName == $NAME",beginDate,endDate];
    NSMutableArray *arrayData = [NSMutableArray arrayWithCapacity:arrayMuscleNames.count];
    for (NSString *name in arrayMuscleNames) {
        NSPredicate *filter = [predicateTemplate predicateWithSubstitutionVariables:@{@"NAME":name}];
        NSNumber *calories = [Muscle MR_aggregateOperation:@"sum:" onAttribute:@"calories" withPredicate:filter];
        NSNumber *trainingTimes = [Muscle MR_aggregateOperation:@"sum:" onAttribute:@"trainingTimes" withPredicate:filter];
        NSDate *lastTrainingDate = [Muscle MR_aggregateOperation:@"max:" onAttribute:@"lastTrainingDate" withPredicate:filter];
        NSNumber *score = [Muscle MR_aggregateOperation:@"sum:" onAttribute:@"score" withPredicate:filter];

        MuscleModel *muscle = [[MuscleModel alloc] init];
        muscle.muscleName = name;
        muscle.calories = calories;
        muscle.trainingTimes = trainingTimes;
        muscle.lastTrainingDate = lastTrainingDate;
        muscle.score = score;

        [arrayData addObject:muscle];
    }
    return arrayData;
}

/**
 *  查询某个周期内肌肉数据
 *
 *  @param beginDate 起始日期
 *  @param endDate   结束日期
 *
 *  @return 肌肉数据数组
 */
- (NSArray<MuscleModel *> *)fetchAllMuscleDataFromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    NSArray *arrayMuscles = @[@"上臂",@"小腿",@"胸",@"肩",@"背",@"大腿",@"腹肌"];
    return [self fetchMuscleData:arrayMuscles FromBeginDate:beginDate endDate:endDate];
}

#pragma mark - Weight
// 保存体重
- (void)saveWeight:(CGFloat)weight {
    [self saveWeight:weight date:[NSDate date]];
}

- (void)saveWeight:(CGFloat)weight date:(NSDate *)date {
    NSDate *currentDate = [DateUtil dateWithComponents:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit date:date];
    
    Weight *lastWeight = [Weight MR_findFirstByAttribute:@"timeStamp" withValue:currentDate];
    if (!lastWeight) {
        Weight *weightEntity = [Weight MR_createEntity];
        weightEntity.weight = [NSNumber numberWithFloat:weight];
        weightEntity.timeStamp = currentDate;
    } else {
        lastWeight.weight = [NSNumber numberWithFloat:weight];
    }
    [self saveToPersistent];

}
// 获得体重
- (NSArray *)fetchWeightWithCount:(NSInteger)count {
    NSArray *arrayWeight = [Weight MR_findAllSortedBy:@"timeStamp" ascending:YES];
    return arrayWeight;
}

// 查询一个周期内体重
- (NSArray<Weight *> *)fetchWeightDataFromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"timeStamp BETWEEN {%@,%@}",beginDate,endDate];
    NSArray *array = [Weight MR_findAllSortedBy:@"timeStamp" ascending:NO withPredicate:predicateTemplate];
    return array;
}


#pragma mark - FatRange
/**
 *  保存体脂率
 */
- (void)saveFatRange:(NSString *)fatRange {
    FatRange *myFatRange = [FatRange MR_findFirst];
    if (!myFatRange) {
        FatRange *myFatRange = [FatRange MR_createEntity];
        myFatRange.fatRange = fatRange;
    } else {
        myFatRange.fatRange = fatRange;
    }
    [self saveToPersistent];
}

/**
 *  查询体脂率
 */
- (FatRange *)fetchFatRange {
    FatRange *fatRange = [FatRange MR_findFirst];
    return fatRange;
}

#pragma mark - Private Method
// 保存数据
- (void)saveToPersistent {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

// 创建肌肉信息数据/测试
- (void)initMuscleData {
     NSArray *arrayMuscles = @[@"上臂",@"小腿",@"胸",@"肩",@"背",@"大腿",@"腹肌",@"上臂",@"小腿",@"胸",@"肩",@"背",@"大腿",@"腹肌",@"上臂",@"小腿",@"胸",@"肩",@"背",@"大腿",@"腹肌",@"上臂",@"小腿",@"胸",@"肩",@"背",@"大腿",@"腹肌",];
    for (NSString *name in arrayMuscles) {
        Muscle *muscle = [Muscle MR_createEntity];
        muscle.muscleName = name;
        muscle.lastTrainingDate = [NSDate date];
        
        muscle.calories = @5;
        muscle.score = @5;
        muscle.trainingTimes = @1;
        [self saveToPersistent];
    }

}

#pragma mark - FetchAll
/**
 *  查询某个周期内所有肌肉综合数据
 *
 *  @param beginDate 起始日期
 *  @param endDate   结束日期
 *
 *  @return 所有肌肉数据
 */
- (MuscleModel *)fetchComprehensiveDataFromBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    NSPredicate *predicateTemplate = [NSPredicate predicateWithFormat:@"lastTrainingDate BETWEEN {%@,%@}",beginDate,endDate];
    NSNumber *calories = [Muscle MR_aggregateOperation:@"sum:" onAttribute:@"calories" withPredicate:predicateTemplate];
    NSNumber *trainingTimes = [Muscle MR_aggregateOperation:@"sum:" onAttribute:@"trainingTimes" withPredicate:predicateTemplate];
    NSDate *lastTrainingDate = [Muscle MR_aggregateOperation:@"max:" onAttribute:@"lastTrainingDate" withPredicate:predicateTemplate];
    NSNumber *score = [Muscle MR_aggregateOperation:@"sum:" onAttribute:@"score" withPredicate:predicateTemplate];

    MuscleModel *muscle = [[MuscleModel alloc] init];
    muscle.muscleName = @"综合数据";
    muscle.calories = calories;
    muscle.trainingTimes = trainingTimes;
    muscle.lastTrainingDate = lastTrainingDate;
    muscle.score = score;
    return muscle;
}
@end

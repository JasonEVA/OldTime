//
//  TrainGetTrainInfoModel.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "BaseRequest.h"

@interface TrainGetTrainInfoModel : BaseRequest
@property (nonatomic, copy) NSString *trainingId;	//训练ID	String
@property (nonatomic, copy) NSString *name;	//训练名称	String
@property (nonatomic, copy) NSString *background;	//背景图	String
@property (nonatomic, copy) NSString *backgroundUrl;	//背景图Url	String
@property (nonatomic, copy) NSDictionary *trainingDescription;	//训练描述	Dictionary
@property (nonatomic) NSInteger difficulty;	//难度	Int
@property (nonatomic, copy) NSString *equipment;	//器械	String
@property (nonatomic) NSInteger totalConsumption;	//总消耗	Int
@property (nonatomic) NSInteger totalTime;	//总天数	Int
@property (nonatomic) NSInteger avgTime;	//平均时长	Int
@property (nonatomic, copy) NSArray *daysDetial;	//每天详细	Array@property (nonatomic, copy)
@end

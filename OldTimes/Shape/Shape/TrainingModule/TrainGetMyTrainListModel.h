//
//  TrainGetMyTrainListModel.h
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainGetMyTrainListModel : NSObject
@property (nonatomic) NSInteger completedDays;	//已完成天数	Int
@property (nonatomic) NSInteger totalTime;	//总天数	Int
@property (nonatomic, copy) NSString *trainingId;	//训练ID	String
@property (nonatomic, copy) NSString *name;	//训练名称	String
@property (nonatomic) NSInteger difficulty;	//难度	int
@property (nonatomic, copy) NSString *background;	//背景图	String
@property (nonatomic, copy) NSString *backgroundUrl;	//背景图Url	String
@property (nonatomic, copy) NSString *supplierName;	//训练提供用户名	String

@end

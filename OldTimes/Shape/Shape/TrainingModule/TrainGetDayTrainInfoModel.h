//
//  TrainGetDayTrainInfoModel.h
//  Shape
//
//  Created by jasonwang on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TrainActionListModel;
@interface TrainGetDayTrainInfoModel : NSObject
@property (nonatomic, copy) NSString *trainingName;	//训练名称	String
@property (nonatomic, copy) NSString *background;	//背景图	String
@property (nonatomic, copy) NSString *backgroundUrl;	//背景图Url	String
@property (nonatomic) NSInteger difficulty;	//难度	int
@property (nonatomic, copy) NSString *equipment;	//器械	String
@property (nonatomic) NSInteger totalTime;	//训练总天数	Int
@property (nonatomic) NSInteger daysNo;	//当前训练（天）	Int
@property (nonatomic, copy) NSString *supplierId;	//训练提供用户ID	String
@property (nonatomic, copy) NSString *supplierIcon;	//训练提供用户头像	String
@property (nonatomic, copy) NSString *supplierName;	//训练提供用户名	String
@property (nonatomic, copy) NSString *daysTrainingName;	//当前日训练名称	String
@property (nonatomic) NSInteger classify;	//当前锻炼类型	Int	0:动作 1:跑步
@property (nonatomic) NSInteger length;	//时长/距离	Int
@property (nonatomic) NSInteger consumption;	//消耗	Int
@property (nonatomic, copy) NSArray<TrainActionListModel *> *actionList;	//动作列表	Array
@end

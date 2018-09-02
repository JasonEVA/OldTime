//
//  TrainGetTrainDataArrayModel.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainGetTrainDataArrayModel : NSObject
@property (nonatomic, copy) NSString *trainingId;	//训练ID	String
@property (nonatomic, copy) NSString *name;	//训练名称	String
@property (nonatomic) NSInteger difficulty;	//难度	int
@property (nonatomic, copy) NSString *background;	//背景图	String
@property (nonatomic, copy) NSString *backgroundUrl;	//背景图Url	String
@property (nonatomic, copy) NSString *supplierName;	//训练提供用户名	String
@property (nonatomic) NSInteger totalTime;	//	int
@property (nonatomic) BOOL isHot;
@end

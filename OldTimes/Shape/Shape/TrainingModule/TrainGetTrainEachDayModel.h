//
//  TrainGetTrainEachDayModel.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrainGetTrainEachDayModel : NSObject
@property (nonatomic, copy) NSString *name;	//日锻炼名	String
@property (nonatomic) NSInteger classify;	//锻炼类型	Int	0：动作锻炼1：跑步锻炼
@property (nonatomic) NSInteger length;	//时长/距离	Int
@end

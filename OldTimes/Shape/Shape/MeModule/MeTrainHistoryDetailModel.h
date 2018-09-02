//
//  MeTrainHistoryDetailModel.h
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeTrainHistoryDetailModel : NSObject
@property (nonatomic, copy)  NSString  *trainingName;	//训练名称	String
@property (nonatomic, copy)  NSString  *daysNo;	//完成训练（天）	String
@property (nonatomic, copy)  NSString  *completionTime;	//完成时间	DateTime
@end

//
//  TrainAddTrainPlanRequest.h
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequest.h"

@interface TrainAddTrainPlanRequest :  BaseRequest

@property (nonatomic, copy) NSString *myID;


@end

@interface TrainAddTrainPlanResponse : BaseResponse

@end
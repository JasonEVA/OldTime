//
//  TrainAddTrainPlanRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainAddTrainPlanRequest.h"
#define Dict_id         @"Identifier"

@implementation TrainAddTrainPlanRequest

-(void)prepareRequest
{
    self.action = @"authapi/addUserTraining";
    self.params[Dict_id] = self.myID;
    [super prepareRequest];
}
@end

@implementation TrainAddTrainPlanResponse



@end
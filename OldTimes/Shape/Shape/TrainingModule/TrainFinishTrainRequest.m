//
//  TrainFinishTrainRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainFinishTrainRequest.h"
#define Dict_identifier     @"identifier"

@implementation TrainFinishTrainRequest
- (void)prepareRequest
{
    self.action = @"authapi/CompletedTraining";
    self.params[Dict_identifier] = self.identifier;
    [super prepareRequest];
}
@end

@implementation TrainFinishTrainResponse



@end
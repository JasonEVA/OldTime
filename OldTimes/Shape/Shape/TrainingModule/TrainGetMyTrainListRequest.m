//
//  TrainGetMyTrainListRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainGetMyTrainListRequest.h"
#import "MyDefine.h"
#import <MJExtension.h>

@implementation TrainGetMyTrainListRequest
- (void)prepareRequest
{
    self.action = @"authapi/getUserTrainingList";
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    TrainGetMyTrainListResponse *response = [[TrainGetMyTrainListResponse alloc]init];

    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        response.modelArr = [TrainGetMyTrainListModel objectArrayWithKeyValuesArray:dict];
    }

    return response;
}
@end

@implementation TrainGetMyTrainListResponse



@end
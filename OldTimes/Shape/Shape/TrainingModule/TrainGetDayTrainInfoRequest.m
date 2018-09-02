//
//  TrainGetDayTrainInfoRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainGetDayTrainInfoRequest.h"
#import <MJExtension.h>
#import "MyDefine.h"



#define Dict_trainID       @"identifier"

@implementation TrainGetDayTrainInfoRequest

- (void)prepareRequest
{
    self.action = @"authapi/getTrainingDaysInfo";
    self.params[Dict_trainID] = self.trainID;
    [super prepareRequest];
}
- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    TrainGetDayTrainInfoResponse *response = [[TrainGetDayTrainInfoResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        response.model = [TrainGetDayTrainInfoModel objectWithKeyValues:dict];
//        NSDictionary *dict1 = [dict objectForKey:@"actionList"];
//        response.actionListArr = [TrainActionListModel objectArrayWithKeyValuesArray:dict1];
        //NSDictionary *dict2 = [dict1 objectForKey:@"scoreList"];
        //NSDictionary *dict2 = [TrainAddMarksModel objectClassInArray:response.actionListArr];
    }
    return response;
}

@end

@implementation TrainGetDayTrainInfoResponse



@end
//
//  TrainGetTrainInfoRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainGetTrainInfoRequest.h"
#import "MyDefine.h"
#import <MJExtension.h>
#import "TrainGetTrainEachDayModel.h"


#define DICT_id            @"Identifier"	//训练ID	String	必填
@implementation TrainGetTrainInfoRequest
- (void)prepareRequest
{
    self.action = @"api/getTrainingInfo";
    self.params[DICT_id] = self.myId;
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    TrainGetTrainInfoResponse *response = [[TrainGetTrainInfoResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        TrainGetTrainInfoModel *model = [TrainGetTrainInfoModel objectWithKeyValues:dict];
        response.model = model;
        NSDictionary *dict1 = [dict objectForKey:@"daysDetial"];
        response.modelArr = [TrainGetTrainEachDayModel objectArrayWithKeyValuesArray:dict1];
    }
    
    return response;

}

@end

@implementation TrainGetTrainInfoResponse



@end
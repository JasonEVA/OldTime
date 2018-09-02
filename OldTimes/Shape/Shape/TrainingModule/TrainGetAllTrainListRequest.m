//
//  TrainGetAllTrainListRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainGetAllTrainListRequest.h"
#import "MyDefine.h"
#import <MJExtension.h>
#import "TrainGetTrainDataArrayModel.h"

#define DICT_pageSize          @"pageSize"	//页容量	Int	非必填	默认为10
#define DICT_pageIndex          @"pageIndex"	//页编号	Int	非必填	默认为1
#define DICT_difficulty          @"difficulty"	//难度	String	非必填	1~5
#define DICT_equipmentId          @"equipmentId"	//器械ID	String	非必填
#define DICT_bodyPort          @"bodyPort"	//锻炼部位（部位ID）	String	非必填

@implementation TrainGetAllTrainListRequest
- (void)prepareRequest
{
    self.action = @"api/getTrainingList";
    self.params[DICT_pageSize] = [NSNumber numberWithInteger:self.pageSize];
    self.params[DICT_pageIndex] = [NSNumber numberWithInteger:self.pageIndex];
    self.params[DICT_difficulty] = self.difficulty;
    self.params[DICT_equipmentId] = self.equipmentId;
    self.params[DICT_bodyPort] = self.bodyPort;

    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    TrainGetAllTrainListResponse *response = [[TrainGetAllTrainListResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        TrainGetTrainListResultModel *model = [TrainGetTrainListResultModel objectWithKeyValues:dict];
        response.model = model;
        NSDictionary *dict1 = [dict objectForKey:@"pageItems"];
        response.modelArr = [TrainGetTrainDataArrayModel objectArrayWithKeyValuesArray:dict1];
    }

    return response;
}
@end

@implementation TrainGetAllTrainListResponse



@end
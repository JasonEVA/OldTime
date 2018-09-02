//
//  MeGetTrainHistoryRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeGetTrainHistoryRequest.h"
#import "MyDefine.h"
#import <MJExtension.h>

#define Dict_pageSize  @"pageSize"	//页容量	Int	非必填	默认为10
#define Dict_pageIndex  @"pageIndex"	//页编号	Int	非必填	默认为1

@implementation MeGetTrainHistoryRequest

- (void)prepareRequest
{
    self.action = @"authapi/getTrainingRecords";
    self.params[Dict_pageSize] = [NSNumber numberWithInteger:self.pageSize];
    self.params[Dict_pageIndex] = [NSNumber numberWithInteger:self.pageIndex];
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MeGetTrainHistoryResponse *response = [[MeGetTrainHistoryResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        MeTrainHistoryListModel *model = [MeTrainHistoryListModel objectWithKeyValues:dict];
        response.model = model;
    }
    
    return response;
}
@end

@implementation MeGetTrainHistoryResponse



@end
//
//  TrainGetTrainToolRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainGetTrainToolRequest.h"
#import "MyDefine.h"
#import <MJExtension.h>
#import "unifiedFilePathManager.h"

@implementation TrainGetTrainToolRequest
- (void)prepareRequest
{
    self.action = @"api/getEquipmentList";
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    TrainGetTrainToolResponse *response = [[TrainGetTrainToolResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        response.modelArr = [TrainToolModel objectArrayWithKeyValuesArray:dict];
        //将器械工具列表缓存到本地沙盒中
        [dict writeToFile:[[unifiedFilePathManager share] getCurrentUserDirectoryWithFolderName:nil fileName:@"TrainTool.plist"] atomically:YES];
    }
    

    return response;
}

@end

@implementation TrainGetTrainToolResponse


@end
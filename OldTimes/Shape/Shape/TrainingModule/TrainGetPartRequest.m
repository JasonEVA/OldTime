//
//  TrainGetPartRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/9.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainGetPartRequest.h"
#import "MyDefine.h"
#import <MJExtension.h>
#import "unifiedFilePathManager.h"

@implementation TrainGetPartRequest
- (void)prepareRequest
{
    self.action = @"api/getBodyPortList";
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    TrainGetPartResponse *response = [[TrainGetPartResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        response.modelArr = [TrainPartModel objectArrayWithKeyValuesArray:dict];
         [dict writeToFile:[[unifiedFilePathManager share] getCurrentUserDirectoryWithFolderName:nil fileName:@"TrainPart.plist"] atomically:YES];
    }
    
    return response;
}

@end

@implementation TrainGetPartResponse



@end
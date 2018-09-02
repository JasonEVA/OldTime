//
//  MeGetCityListRequest.m
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeGetCityListRequest.h"
#import "MyDefine.h"
#import <MJExtension.h>

#define Dict_AreaTtpe         @"areaType"
#define Dict_AreaCode         @"areaCode"

@implementation MeGetCityListRequest

- (void)prepareRequest
{
    self.action = @"api/getAreaList";
    self.params[Dict_AreaTtpe] = [NSNumber numberWithInteger:self.areaType];
    self.params[Dict_AreaCode] = self.areaCode;
    [super prepareRequest];
}


- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    
    MeGetCityListResponse *reponse = [[MeGetCityListResponse alloc]init];
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        NSArray *array = [MeCityListModel objectArrayWithKeyValuesArray:dict];
        reponse.modelArr = array;
    }
    
    return reponse;
}

@end


@implementation MeGetCityListResponse



@end
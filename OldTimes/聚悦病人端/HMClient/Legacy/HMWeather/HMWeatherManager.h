//
//  HMWeatherManager.h
//  HMClient
//
//  Created by jasonwang on 2017/7/26.
//  Copyright © 2017年 YinQ. All rights reserved.
//  天气工具类

#import <Foundation/Foundation.h>

@class HMWeatherModel;

typedef void(^HMWeatherBlock)(BOOL isSuccess,HMWeatherModel *model);

@interface HMWeatherManager : NSObject

+ (id)shareInstance;

// 获取当时天气
- (void)HMStartGetCurrentWeatherWithCityCode:(NSString *)cityCode block:(HMWeatherBlock)block;
@end

/*
 http://lbs.amap.com/api/webservice/guide/api/ipconfig
 http://lbs.amap.com/api/webservice/guide/api/weatherinfo
 
*/

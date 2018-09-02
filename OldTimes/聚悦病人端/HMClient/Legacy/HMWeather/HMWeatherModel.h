//
//  HMWeatherModel.h
//  HMClient
//
//  Created by jasonwang on 2017/7/21.
//  Copyright © 2017年 YinQ. All rights reserved.
//  天气model

#import <Foundation/Foundation.h>

@interface HMWeatherModel : NSObject
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *weather;
@property (nonatomic, copy) NSString *temperature;

@end

//
//  HMWeatherManager.m
//  HMClient
//
//  Created by jasonwang on 2017/7/26.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeatherManager.h"
#import "HMWeatherModel.h"

#define AMAPKEY @"2dd2ddf066b22df308a3881f2e889744"

@interface HMWeatherManager ()
@property (nonatomic, copy) HMWeatherBlock block;
@end

@implementation HMWeatherManager

- (AFHTTPSessionManager *)sharedHTTPSession{
    static AFHTTPSessionManager *sessionManager = nil ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 初始化Manager
        sessionManager = [AFHTTPSessionManager manager];
        sessionManager.requestSerializer=[AFJSONRequestSerializer serializer];
        // 不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
        sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        sessionManager.requestSerializer.timeoutInterval = 30.0;
        
    });
    return sessionManager;
}


+ (id)shareInstance
{
    static id manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (void)HMStartGetCurrentWeatherWithCityCode:(NSString *)cityCode block:(HMWeatherBlock)block {
    [self getWeatherWithAdcode:cityCode];
    
    self.block = block;
}

// IP 定位
- (void)HMGetIpLocation {
    
    // 初始化Manager
    AFHTTPSessionManager *manager = [self sharedHTTPSession];
    // GET请求
    [manager GET:[NSString stringWithFormat:@"http://restapi.amap.com/v3/ip?key=%@",AMAPKEY] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* strResp = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *respResult = [NSObject JSONValue:strResp];
        NSString *adcode = respResult[@"adcode"];
        if (adcode && adcode.length) {
            [self getWeatherWithAdcode:adcode];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.block) {
            self.block(NO, nil);
        }
    }];
}
// 获取天气
- (void)getWeatherWithAdcode:(NSString *)adcode {
    if (!adcode || !adcode.length) {
        return;
    }
    // 初始化Manager
    AFHTTPSessionManager *manager = [self sharedHTTPSession];
    // GET请求
    [manager GET:[NSString stringWithFormat:@"http://restapi.amap.com/v3/weather/weatherInfo?city=%@&key=%@",adcode,AMAPKEY] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString* strResp = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *respResult = [NSObject JSONValue:strResp];
        NSArray *modelArr = [HMWeatherModel mj_objectArrayWithKeyValuesArray:respResult[@"lives"]];
        if (modelArr && modelArr.count) {
            
            HMWeatherModel *model = modelArr.firstObject;
            if (model && [model isKindOfClass:[HMWeatherModel class]] && model.weather && model.weather.length) {
                if (self.block) {
                    self.block(YES, model);
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.block) {
            self.block(NO, nil);
        }
    }];

}
@end

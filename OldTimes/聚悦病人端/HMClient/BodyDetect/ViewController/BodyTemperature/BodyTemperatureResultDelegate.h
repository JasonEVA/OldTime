//
//  BodyTemperatureResultDelegate.h
//  BlueToothDemo
//
//  Created by yinquan on 17/4/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BodyTemperatureErrorCode) {
    Error_None,
    Error_DataError,        //读取设备数据出错
    Error_DeviceError,      //设备错误
};

@protocol BodyTemperatureResultDelegate <NSObject>

- (void) temperature:(CGFloat) temperature error:(BodyTemperatureErrorCode) errorCode;

- (void) temperature:(CGFloat) temperature error:(BodyTemperatureErrorCode) errorCode deviceError:(NSInteger) deviceError;
@end

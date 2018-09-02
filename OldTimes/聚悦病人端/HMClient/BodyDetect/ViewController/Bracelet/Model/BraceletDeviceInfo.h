//
//  BraceletDeviceInfo.h
//  HMClient
//
//  Created by lkl on 2017/9/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BraceletDeviceInfo : NSObject

@property (nonatomic, copy) NSString *calorie;      //千卡
@property (nonatomic, copy) NSString *data_from;    //数据从那个设备获得
@property (nonatomic, strong) NSDate *date;         //日期
@property (nonatomic, copy) NSString *detail_data;
@property (nonatomic, assign) NSInteger day;
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger week;
@property (nonatomic, assign) float distance;       //距离 m
@property (nonatomic, copy) NSString *sport_type;   //运动方式
@property (nonatomic, assign) NSInteger steps;      //步数

@end


@interface BraceletConnectDeviceInfo : NSObject<NSCoding>
@property (nonatomic, copy) NSString *data_from;    //数据从那个设备获得
@property (nonatomic, copy) NSString *date;         //日期
@end

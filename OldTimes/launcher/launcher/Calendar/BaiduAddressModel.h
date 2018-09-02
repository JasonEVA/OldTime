//
//  BaiduAddressModel.h
//  launcher
//
//  Created by jasonwang on 16/1/4.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaiduAddressModel : NSObject
@property (nonatomic, copy) NSString *keyword;  //关键词
@property (nonatomic, copy) NSString *cityNmae; //城市名
@property (nonatomic, copy) NSString *district; //区名
///poiId列表，成员是NSString
@property (nonatomic, copy) NSString *poiId;
///pt列表，成员是：封装成NSValue的CLLocationCoordinate2D
@property (nonatomic, copy) NSValue *pt;
@end

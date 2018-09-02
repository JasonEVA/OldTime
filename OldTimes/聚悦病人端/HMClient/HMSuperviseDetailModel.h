//
//  HMSuperviseDetailModel.h
//  HMClient
//
//  Created by jasonwang on 2017/7/10.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMSuperviseEachPointModel;

@interface HMSuperviseDetailModel : NSObject
@property (nonatomic) long long endday;
@property (nonatomic) long long startday;
@property (nonatomic) NSInteger testCount;
@property (nonatomic) long long first;
@property (nonatomic, copy) NSArray <HMSuperviseEachPointModel *>*datalist;

@end

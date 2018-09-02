//
//  HMAdsModel.h
//  HMClient
//
//  Created by JasonWang on 2017/5/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//  广告model

#import <Foundation/Foundation.h>

@interface HMAdsModel : NSObject
@property (nonatomic, copy) NSString *imgUrlSmall;
@property (nonatomic, copy) NSString *imgUrlBig;
@property (nonatomic, copy) NSString *linkUrl;
@property (nonatomic) long long contentId;
@property (nonatomic) long long playTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *positionCode;
@property (nonatomic, copy) NSString *contentName;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *opTime;
@property (nonatomic) long long sortRank;

@property (nonatomic) long long JWOperator;

@property (nonatomic, copy) NSString *startTime;
@end

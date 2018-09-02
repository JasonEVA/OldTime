//
//  HMLoseWeightPkModel.h
//  HMClient
//
//  Created by jasonwang on 2017/8/11.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HMLoseWeightPkModel : NSObject

@property (nonatomic) CGFloat dValue;
@property (nonatomic, copy) NSString *updateTime;
@property (nonatomic, copy) NSString *timeType;
@property (nonatomic, copy) NSString *exerciseTzId;
@property (nonatomic) long long userId;
@property (nonatomic, copy) NSString *userName;

@end

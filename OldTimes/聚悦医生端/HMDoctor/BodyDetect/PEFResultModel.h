//
//  PEFResultModel.h
//  HMClient
//
//  Created by lkl on 2017/6/13.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEFResultModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) NSString *symptoms;
@property (nonatomic, copy) NSString *maxOfHistory;
@property (nonatomic, copy) NSString *variationRate;
@property (nonatomic, copy) NSString *testDate;

@end

@interface PEFResultdataListModel : NSObject

@property (nonatomic, copy) NSString *TEST_TIME;
@property (nonatomic, copy) NSString *TEST_VALUE;
@property (nonatomic, copy) NSString *TEST_VALUE_UNIT;
@property (nonatomic, copy) NSString *TEST_TIME_NAME;
@property (nonatomic, copy) NSString *TEST_DATE;

@end

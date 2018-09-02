//
//  IntegralRecordModel.h
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntegralRecordModel : NSObject

@property (nonatomic, retain) NSString* createTime;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, retain) NSString* remark;
@property (nonatomic, assign) NSInteger sourceId;
@property (nonatomic, retain) NSString* sourceName;
@property (nonatomic, assign) NSInteger status;

@end

@interface IntegralMonthRecordModel : NSObject

@property (nonatomic, retain) NSString* time;
@property (nonatomic, assign) NSInteger totalNum;
@property (nonatomic, assign) NSInteger useNum;
@property (nonatomic, retain) NSArray* userIntegerDetailsVOS;

- (void) combineMonthModel:(IntegralMonthRecordModel*) monthModel;
@end

@interface IntegralSourceRecordModel : NSObject

@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, retain) NSArray* results;

@end

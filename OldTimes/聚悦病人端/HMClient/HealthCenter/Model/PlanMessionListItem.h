//
//  PlanMessionListItem.h
//  HMClient
//
//  Created by yinqaun on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanMessionListItem : NSObject
{
    
}

@property (nonatomic, retain) NSString* code;
@property (nonatomic, retain) NSString* kpiCode;

@property (nonatomic, assign) NSInteger healthyId;
@property (nonatomic, retain) NSString* planId;
@property (nonatomic, retain) NSString* taskId;

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* taskCon;
@property (nonatomic, copy) NSString *status;
/**
 *  0 未开始     1 待记录    2 已记录    3 已过期
 */
@property (nonatomic, retain) NSString* excTime;
@property (nonatomic, retain) NSString* statusName;

//@property (nonatomic, retain) NSArray* datas;

- (NSString*) excTimeString;


- (UIColor*) statusColor;

- (CGFloat) cellHeihgt;
@end

//
//  EvaluationListRecord.h
//  HMClient
//
//  Created by lkl on 16/8/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvaluationListRecord : NSObject

@property (nonatomic,copy)NSString *itemId;
@property (nonatomic,copy)NSString *itemName;

//1.阶段评估  2.单项评估   3.建档评估
@property (nonatomic,copy)NSString *itemType;
@property (nonatomic,copy)NSString *orgName;
@property (nonatomic,copy)NSString *time;

@end

@interface UserHealtySummaryInfo : NSObject

@property (nonatomic,assign)NSInteger age;
@property (nonatomic,copy)NSString *healtyRecordId;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,assign)NSInteger status;
@property (nonatomic,copy)NSString *templateId;
@property (nonatomic,copy)NSString *templateName;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic,copy)NSString *userName;

@end
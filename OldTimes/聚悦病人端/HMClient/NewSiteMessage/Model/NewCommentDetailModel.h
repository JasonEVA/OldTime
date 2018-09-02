//
//  NewCommentDetailModel.h
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版评价 评价详情 model

#import <Foundation/Foundation.h>
#import "NewCommentEvaluateTagModel.h"

@interface NewCommentDetailModel : NSObject
@property (nonatomic) NSInteger teamId;
@property (nonatomic) NSInteger userId;
@property (nonatomic) NSInteger productId;
@property (nonatomic) NSInteger userServiceId;
@property (nonatomic) NSInteger staffUserId;
@property (nonatomic, copy) NSString *remariks;
@property (nonatomic, copy) NSString *evaluateId;
@property (nonatomic, copy) NSString *orgGroupCode;
@property (nonatomic, copy) NSString *evaluateTime;
@property (nonatomic, copy) NSArray <NewCommentEvaluateTagModel *>*evaluateTarget;

@end

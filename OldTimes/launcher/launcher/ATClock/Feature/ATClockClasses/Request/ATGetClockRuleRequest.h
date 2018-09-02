//
//  ATGetClockRuleRequest.h
//  Clock
//
//  Created by SimonMiao on 16/7/22.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATHttpBaseRequest.h"

@class ATGetClockRuleModel;
@interface ATGetClockRuleResponse : ATHttpBaseResponse

@property (nonatomic, strong) ATGetClockRuleModel *ruleModel;

@end

@interface ATGetClockRuleRequest : ATHttpBaseRequest

@property (nonatomic, copy) NSString *orgId;
@property (nonatomic, copy) NSString *userId;

@end

//
//  ApplyDealWiththeApplyV2Request.h
//  launcher
//
//  Created by williamzhang on 16/4/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ApplyDealWiththeApplyV2Request : BaseRequest
- (void)GetShowID:(NSString *)ShowID WithStatus:(NSString *)status WithReason:(NSString *)Reason;
@end

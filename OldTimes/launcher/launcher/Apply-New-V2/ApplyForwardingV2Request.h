//
//  ApplyForwardingV2Request.h
//  launcher
//
//  Created by williamzhang on 16/4/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ApplyForwardingV2Response : BaseResponse

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@interface ApplyForwardingV2Request : BaseRequest

- (void)GetShowID:(NSString *)ShowID WithApprove:(NSString *)Approve WithApproveName:(NSString *)ApproveName WithReason:(NSString *)Reason;

@end

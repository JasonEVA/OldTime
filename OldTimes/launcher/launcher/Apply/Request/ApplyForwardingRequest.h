//
//  ApplyForwardingRequest.h
//  launcher
//
//  Created by Conan Ma on 15/9/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ApplyForwardingResponse : BaseResponse
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@interface ApplyForwardingRequest : BaseRequest

- (void)GetShowID:(NSString *)ShowID WithApprove:(NSString *)Approve WithApproveName:(NSString *)ApproveName WithReason:(NSString *)Reason;

@end

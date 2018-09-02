//
//  UpDateCommmentRequest.h
//  launcher
//
//  Created by jasonwang on 16/2/26.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface UpDateCommmentRequest : BaseRequest
- (void)updateWithshowID:(NSString *)showID isComment:(NSString *)isComment;
@end

@interface UpDateCommmentResponse : BaseResponse
@property (nonatomic) BOOL isSuccess;

@end
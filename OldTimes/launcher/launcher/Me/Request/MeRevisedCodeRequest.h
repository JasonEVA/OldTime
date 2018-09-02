//
//  MeRevisedCodeRequest.h
//  launcher
//
//  Created by conanma on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface MeRevisedCodeResponse : BaseResponse
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@interface MeRevisedCodeRequest : BaseRequest
- (void)getShowID:(NSString *)showid oldPassword:(NSString *)oldPW newPassword:(NSString *)newPW;
@end

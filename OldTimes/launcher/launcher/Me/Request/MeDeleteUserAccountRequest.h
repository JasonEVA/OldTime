//
//  MeDeleteUserAccountRequest.h
//  launcher
//
//  Created by conanma on 15/10/14.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface MeDeleteUserAccountResponse : BaseResponse
@property (nonatomic, strong) NSMutableDictionary *dict;
@end


@interface MeDeleteUserAccountRequest : BaseRequest
- (void)GetShowID:(NSString *)showID;
@end

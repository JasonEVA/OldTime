//
//  ApplySearchRequest.h
//  launcher
//
//  Created by Conan Ma on 15/9/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ApplySearchResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *arrResultApproveList;
@property (nonatomic, strong) NSMutableArray *arrResultTitleList;
@end

@interface ApplySearchRequest : BaseRequest
- (void)GetKeyWord:(NSString *)Keywords;
@end

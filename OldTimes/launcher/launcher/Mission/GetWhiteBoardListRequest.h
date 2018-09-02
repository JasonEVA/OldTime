//
//  GetWhiteBoardListRequest.h
//  launcher
//
//  Created by William Zhang on 15/9/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  获取白板列表

#import "BaseRequest.h"

@interface GetWhiteBoardListResponse : BaseResponse

@property (nonatomic, strong) NSArray *arrayWhiteBoard;
@property (nonatomic, readonly) NSString *projectShowId;

@end

@interface GetWhiteBoardListRequest : BaseRequest

- (void)getProjectWhiteBoard:(NSString *)projectShowId;

@end

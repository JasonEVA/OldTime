//
//  ApplyGetReceivedApplyListRequest.h
//  launcher
//
//  Created by Conan Ma on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ApplyGetReceivedApplyListResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *arrData;
@end

@interface ApplyGetReceivedApplyListRequest : BaseRequest
//receiver
- (void)GetType:(NSString *)type IS_PROCESS:(NSInteger)IS_PROCESS pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize timeStamp:(NSDate *)date;
- (void)GetType:(NSString *)type IS_PROCESS:(NSInteger)IS_PROCESS pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

//cc
- (void)GetType:(NSString *)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize timeStamp:(NSDate *)date;
- (void)GetType:(NSString *)type pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end

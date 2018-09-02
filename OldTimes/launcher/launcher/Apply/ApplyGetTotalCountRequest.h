//
//  ApplyGetTotalCountRequest.h
//  launcher
//
//  Created by Kyle He on 15/9/23.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ApplyGetTotalCountResponse: BaseResponse
@property (nonatomic, strong) NSMutableArray *arrData;
@end

@interface ApplyGetTotalCountRequest : BaseRequest
- (void)GetType:(NSString *)type IS_PROCESS:(NSInteger)IS_PROCESS pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize timeStamp:(NSDate *)date;
- (void)GetType:(NSString *)type IS_PROCESS:(NSInteger)IS_PROCESS pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;
@end

//
//  ApplyGetSenderListRequest.h
//  launcher
//
//  Created by Kyle He on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"
#import "ApplyGetSendListModel.h"
#import "ApplyGetReceiveListModel.h"

@interface ApplyGetSenderListResponse : BaseResponse

@property(nonatomic, strong) NSMutableArray  *modelArr;

@end

@interface ApplyGetSenderListRequest : BaseRequest

- (void)getSenderListRequstWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)PageSize TimeStamp:(NSDate *)date;
- (void)getSenderListRequstWithPageIndex:(NSInteger)pageIndex PageSize:(NSInteger)PageSize;
@end

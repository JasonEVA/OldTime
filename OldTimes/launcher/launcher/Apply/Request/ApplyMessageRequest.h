//
//  ApplyMessageRequest.h
//  launcher
//
//  Created by Conan Ma on 15/9/16.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"
#import "ApplyMessageModel.h"

@interface ApplyMessageResponse : BaseResponse
@property (nonatomic, strong) NSMutableArray *arrMessageModel;

@end

@interface ApplyMessageRequest : BaseRequest

- (void)GetUnreadMessagesWithpageIndex:(NSInteger)pageIndex timeStamp:(NSDate *)timeStamp appShowID:(NSString *)appShowID readStatus:(NSInteger)readStatus messageType:(NSString *)messageType;

- (void)getMessageList;


@end

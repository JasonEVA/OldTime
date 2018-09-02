//
//  GetFriendInfolistRequest.h
//  MintcodeIM
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  好友列表(非增量 )

#import "IMBaseBlockRequest.h"

@interface GetFriendInfolistRequest : IMBaseBlockRequest

+ (void)getFriendListRequestCompletion:(IMBaseResponseCompletion)completion;

@end

@interface GetFriendInfolistResponse : IMBaseResponse

@property (nonatomic,strong) NSMutableArray *  dataArray;

@end
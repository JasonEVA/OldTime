//
//  SearchRelationUserRequest.h
//  MintcodeIM
//
//  Created by TabLiu on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  搜索好友-- 精确搜素

#import "IMBaseBlockRequest.h"

@interface SearchRelationUserRequest : IMBaseBlockRequest

+ (void)searchRelationUserWithString:(NSString *)string completion:(IMBaseResponseCompletion)completion;

@end

@interface SearchRelationUserResponse : IMBaseResponse

@property (nonatomic,strong) NSMutableArray * dataArray ;

@end
//
//  RelationValidateListRequest.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  好友验证列表request

#import "IMBaseBlockRequest.h"

@class MessageRelationValidateModel;

@interface RelationValidateListRequest : IMBaseBlockRequest

+ (void)validateListWithUserCompletion:(IMBaseResponseCompletion)completion;
@end

@interface RelationValidateListResponse : IMBaseResponse

@property (nonatomic, strong) NSArray <MessageRelationValidateModel *>* array;

@end
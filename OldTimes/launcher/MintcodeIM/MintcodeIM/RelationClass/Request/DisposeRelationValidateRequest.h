//
//  DisposeRelationValidateRequest.h
//  MintcodeIM
//
//  Created by TabLiu on 16/3/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMBaseBlockRequest.h"
#import "MessageRelationValidateModel.h"

@interface DisposeRelationValidateRequest : IMBaseBlockRequest

/**
 *  处理好友请求
 *
 *  @param model           好友请求model
 *  @param state           2:同意 3:拒绝 4:忽略
 *  @param relationGroupId 好友分组id 不需要时填-1
 *  @param remark          备注
 *  @param content         验证内容
 *  @param completion      是否完成
 */
+ (void)dealRelationWithModel:(MessageRelationValidateModel *)model
                validateState:(NSInteger)state
              relationGroupId:(long)relationGroupId
                       remark:(NSString *)remark
                      content:(NSString *)content
                   completion:(IMBaseResponseCompletion)completion;

@end

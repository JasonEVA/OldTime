//
//  AddRelationValidateRequest.h
//  MintcodeIM
//
//  Created by TabLiu on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  邀请(添加)好友

#import "IMBaseBlockRequest.h"

@interface AddRelationValidateRequest : IMBaseBlockRequest

@property (nonatomic,strong) NSString * fromNickName ;//邀请者昵称
@property (nonatomic,strong) NSString * from ; // 发送者
@property (nonatomic,strong) NSString * fromAvatar ; // 邀请者头像
@property (nonatomic,strong) NSString * to ; // 被邀请者
@property (nonatomic,strong) NSString * remark ; // 备注
@property (nonatomic,strong) NSString * content ; // 验证信息
@property (nonatomic,assign) long       relationGroupId ; // 分组id

+ (void)addRelationValidateRequestTo:(NSString *)toUid
                              remark:(NSString *)remark
                             content:(NSString *)content
                     relationGroupId:(long)relationGroupId
                          completion:(IMBaseResponseCompletion)completion;

@end

//
//  IMMessageMarkRequest.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMBaseBlockRequest.h"

@class MessageBaseModel;

@interface IMMessageMarkRequest : IMBaseBlockRequest

+ (void)markMessageModel:(MessageBaseModel *)model completion:(IMBaseResponseCompletion)completion;

@end

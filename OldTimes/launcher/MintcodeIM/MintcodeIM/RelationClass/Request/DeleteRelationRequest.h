//
//  DeleteRelationRequest.h
//  MintcodeIM
//
//  Created by TabLiu on 16/3/25.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMBaseBlockRequest.h"

@interface DeleteRelationRequest : IMBaseBlockRequest

+ (void)deleteRelationWithUid:(NSString *)uid  completion:(void (^)(BOOL isSuccess))completion;

@end

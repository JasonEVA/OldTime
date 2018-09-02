//
//  modifyRelationGroupRequest.h
//  MintcodeIM
//
//  Created by kylehe on 16/5/13.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMBaseBlockRequest.h"

@interface modifyRelationGroupRequest : IMBaseBlockRequest

+ (void)modifyRelationGroupWithGroupId:(long) groupId relationName:(NSString *)name completion:(void(^)(BOOL isSuccess))completion;

@end

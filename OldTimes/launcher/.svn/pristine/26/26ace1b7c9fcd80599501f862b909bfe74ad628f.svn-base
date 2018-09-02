//
//  DeleteRelationGroupRequest.m
//  MintcodeIM
//
//  Created by kylehe on 16/5/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "DeleteRelationGroupRequest.h"

@implementation DeleteRelationGroupRequest

- (NSString *)action { return @"/deleteRelationGroup";}

+ (void)deleteRelationWithGroupId:(NSString *)groudId completion:(void (^)(BOOL isSuccess))completion
{
    DeleteRelationGroupRequest *request = [[DeleteRelationGroupRequest alloc] init];
    [request.params setValue:groudId forKey:@"relationGroupId"];
    [request  requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        if (completion)
        {
            completion(success);
        }
    }];
    
}

@end

//
//  GetSuperGroupListRequest.h
//  MintcodeIM
//
//  Created by Dee on 16/6/27.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMBaseBlockRequest.h"

@interface GetSuperGroupListRequest : IMBaseBlockRequest

+ (void)GetSuperGroupListFromChache:(BOOL)isfromchache Completion:(IMBaseResponseCompletion)completion;
@end


@interface GetSuperGroupListResponse : IMBaseResponse

@property(nonatomic, strong) NSMutableArray  *modelArray;

@end

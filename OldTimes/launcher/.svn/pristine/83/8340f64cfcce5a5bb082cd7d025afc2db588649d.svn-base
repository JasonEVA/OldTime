//
//  NewApplyGetApproveListV2Reqeust.h
//  launcher
//
//  Created by williamzhang on 16/4/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"
#import "ApplyGetReceiveListModel.h"

@interface NewApplyGetApproveListV2Response : BaseResponse

@property (nonatomic, strong) NSArray<ApplyGetReceiveListModel *> *modelLists;

@end

@interface NewApplyGetApproveListV2Request : BaseRequest

/// keyword为空时获取全部
- (void)listWithKeyword:(NSString *)keyword;

@end

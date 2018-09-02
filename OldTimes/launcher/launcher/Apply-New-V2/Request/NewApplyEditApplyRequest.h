//
//  NewApplyEditApplyRequest.h
//  launcher
//
//  Created by Dee on 16/8/15.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  编辑审批 与 新建的时候基本相同

#import "BaseRequest.h"
@class NewApplyAllFormModel;

@interface NewApplyEditApplyRequest : BaseRequest

- (void)editApplyWithApplyTypeShowID:(NSString *)applyTypeShowId
                          workflowId:(NSString *)workflowId
                         ApplyShowID:(NSString *)applyshowid
                      dateModelArray:(NewApplyAllFormModel *)formModel
                            isUrgent:(BOOL)isurgent;

@end

@interface NewApplyEditApplyResponse: BaseResponse

@end
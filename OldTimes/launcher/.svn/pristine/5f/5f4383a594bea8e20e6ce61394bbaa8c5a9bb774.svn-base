//
//  NewApplyMakeApplyRequet.h
//  launcher
//
//  Created by Dee on 16/8/12.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  创建审批，用于替换之前的NewApplyCreateV2Request

#import "BaseRequest.h"
@class NewApplyAllFormModel;
@interface NewApplyMakeApplyRequet : BaseRequest


- (void)createApplyWithApplyShowID:(NSString *)approveShowId
                        workflowId:(NSString *)workflowId
                    dateModelArray:(NewApplyAllFormModel *)formModel
                          isUrgent:(BOOL)isurgent;
@end

@interface NewApplyMakeApplyResponse : BaseResponse

@end
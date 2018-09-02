//
//  NewApplyGetFormInfoV2Request.h
//  launcher
//
//  Created by Dee on 16/8/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  仅为创建和编辑的时候请求数据

#import "BaseRequest.h"
@class NewApplyAllFormModel;
@interface NewApplyGetFormInfoV2Request : BaseRequest
- (void)getFormWithFormID:(NSString *)formid;
@end

@interface NewApplyGetFormInfoV2Response : BaseResponse
//表单ID
@property(nonatomic, copy) NSString  *formID;
//表单model -- 用于存放所有表单数据的model
@property(nonatomic, strong) NewApplyAllFormModel  *formModel;

@end
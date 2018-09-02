//
//  NewApplyGetFormInfoRequest.h
//  launcher
//
//  Created by 马晓波 on 16/4/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@class NewApplyAllFormModel;

@interface NewApplyGetFormInfoResponse : BaseResponse

@property (nonatomic, strong) NewApplyAllFormModel *model;
//仅用于保存表单格式
@property(nonatomic, copy) NSString  *formStr;
@property (nonatomic, strong) NSString *strFormID;
@property (nonatomic, strong) NSString *strID; //貌似没啥什么卵用

@end

@interface NewApplyGetFormInfoRequest : BaseRequest
- (void)getFormId:(NSString *)string;
@end

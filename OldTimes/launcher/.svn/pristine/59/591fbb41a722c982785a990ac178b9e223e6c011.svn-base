//
//  NewApplyCreatAndEditViewController.h
//  launcher
//
//  Created by Dee on 16/8/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"

//extern NSString *const MCApplyListDataDidRefreshNotification;

typedef NS_ENUM(NSInteger,ApplyType)
{
    kNewApply_Type_Add = 0,
    kNewApply_Type_Edit
};

@class NewApplyFormBaseModel;
@class ApplyDetailInformationModel;
@interface NewApplyCreatAndEditViewController : BaseViewController

/**
 *  审批类型id
 */
@property(nonatomic, copy) NSString  *applyTypeShowID;

//新建
- (instancetype)initWithFormID:(NSString *)formID WorkFlowID:(NSString *)workflowid ApplyType:(ApplyType)type;

//编辑
- (instancetype)editWithFormID:(NSString *)formID WorkFlowID:(NSString *)workflowID EditModel:(ApplyDetailInformationModel *)editModel attachMentArray:(NSMutableArray *)array;

@end

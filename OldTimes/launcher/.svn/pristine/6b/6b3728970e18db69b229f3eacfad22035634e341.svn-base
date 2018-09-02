//
//  NewApplyAddNewApplyV2ViewController.h
//  launcher
//
//  Created by williamzhang on 16/4/28.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyDetailInformationModel.h"

typedef void(^takebackImgArray)(NSMutableArray *);

extern NSString *const MCApplyListDataDidRefreshNotification;

typedef NS_ENUM(NSInteger, ApplyActionType) {
    ApplyActionTypeAdd = 0,
    ApplyActionTypeEdit,
};

typedef NS_ENUM(NSInteger, ApplyContentType) {
    ApplyContentTypeVocation = 0,
    ApplyContentTypeExpense,
};

@interface NewApplyAddNewApplyV2ViewController : BaseViewController
@property (nonatomic) ApplyActionType applytype;
@property (nonatomic) ApplyContentType applykind;
@property (nonatomic, strong) ApplyDetailInformationModel *model;
@property (nonatomic, strong) NSMutableArray *arrattachment;    //照片model数组;

- (void)takebackarray:(takebackImgArray)takebackImgblock;
- (instancetype)initWithApplykind:(ApplyContentType)kind workflowId:(NSString *)workflowId formId:(NSString *)formId;
- (instancetype)initWithEditModel:(ApplyDetailInformationModel *)model appKind:(ApplyContentType)kind;
@end

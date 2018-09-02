//
//  NewApplyAddNewApplyViewController.h
//  launcher
//
//  Created by conanma on 16/1/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyDetailInformationModel.h"

typedef void(^takebackImgArray)(NSMutableArray *);

typedef enum
{
    Edit_Apply,
    New_Apply,
}apply_type;

typedef enum{
    applykind_nil,
    applykind_vocation,
    applykind_expense,
}applykind;

@interface NewApplyAddNewApplyViewController : BaseViewController
@property (nonatomic, assign) apply_type applytype;
@property (nonatomic, assign) applykind applykind;
@property (nonatomic, strong) ApplyDetailInformationModel *model;
@property (nonatomic, strong) NSMutableArray *arrattachment;    //照片model数组;

- (void)takebackarray:(takebackImgArray)takebackImgblock;
- (instancetype)initWithApplykind:(applykind)kind;
@end

//
//  NewApplyAddNewUserDefindedApplyViewController.h
//  launcher
//
//  Created by conanma on 16/1/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  已NewestApplyAddUserDefinedViewController 为准 废弃掉

#import "BaseViewController.h"
#import "ApplyDetailInformationModel.h"

typedef void(^takebackImgArray)(NSMutableArray *);

typedef enum
{
    apply_type_edit,
    apply_type_new,
}applyuserdefined_type;

@interface NewApplyAddNewUserDefindedApplyViewController : BaseViewController
@property (nonatomic) applyuserdefined_type applytype;
@property (nonatomic, strong) NSString *strNavTitle;
@property (nonatomic, strong) ApplyDetailInformationModel *model;
@property (nonatomic, strong) NSMutableArray *arrattachment;    //照片model数组;
@property (nonatomic, strong) NSString *strworkflowID;
- (void)takebackarray:(takebackImgArray)takebackImgblock;
- (instancetype)initWithApplyStyle:(applyuserdefined_type)type WithApplyShowID:(NSString *)strID;
@end

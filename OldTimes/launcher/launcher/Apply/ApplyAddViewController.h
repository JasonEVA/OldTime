//
//  AddApplyViewController.h
//  launcher
//
//  Created by Kyle He on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  追加详情休假申请

#import "BaseViewController.h"
#import "ApplyDetailInformationModel.h"

typedef void(^takebackImgArray)(NSMutableArray *);

typedef NS_ENUM(NSInteger, APPLYTYPE)
{
    kEditApply = 0,
    kNewApply = 1,
};

@interface ApplyAddViewController : BaseViewController

@property (nonatomic, strong) ApplyDetailInformationModel *model;
@property (nonatomic, strong) NSMutableArray *arrattachment;    //照片model数组;

- (instancetype)initWithFrom:(APPLYTYPE)comefrom_VC;
- (void)takebackarray:(takebackImgArray)takebackImgblock;

@end

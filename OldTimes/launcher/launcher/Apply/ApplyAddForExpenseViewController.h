//
//  ApplyAddForExpenseViewController.h
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  追加费用申请

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ApplyDetailInformationModel.h"
#import "ApplyAddViewController.h"

typedef void(^takebackImgArray)(NSMutableArray *);

@interface ApplyAddForExpenseViewController : BaseViewController

@property(nonatomic, strong) ApplyDetailInformationModel  *model;
@property (nonatomic, strong) NSMutableArray *arrattachment;    //照片model数组;

-(instancetype)initWithFrom:(APPLYTYPE)comefrom_VC;
- (void)takebackarray:(takebackImgArray)takebackImgblock;
@end

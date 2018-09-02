//
//  ApplyAddNewUserDefinedViewController.h
//  launcher
//
//  Created by conanma on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "ApplyDetailInformationModel.h"

typedef void(^takebackImgArray)(NSMutableArray *);

typedef enum
{
    EditApply = 0,
    NewApply = 1,
}applytp;

@interface ApplyAddNewUserDefinedViewController : BaseViewController
@property(nonatomic, strong) ApplyDetailInformationModel *model;
@property (nonatomic, strong) NSMutableArray *arrattachment;    //照片model数组;
- (instancetype)initWithShowID:(NSString *)showID type:(applytp)type;
- (void)takebackarray:(takebackImgArray)takebackImgblock;

@end

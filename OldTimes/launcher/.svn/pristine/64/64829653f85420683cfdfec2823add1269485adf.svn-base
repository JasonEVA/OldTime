//
//  NewApplyAllFormModel.h
//  launcher
//
//  Created by 马晓波 on 16/4/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NewApplyFormBaseModel;

@interface NewApplyAllFormModel : NSObject

@property (nonatomic, strong) NSMutableArray <NewApplyFormBaseModel *>* arrFormModels;

/// 用于详情UI显示的
@property (nonatomic, strong) NSArray <NSArray<NewApplyFormBaseModel *> *>*showFormModels;
//用户存放表单的原始数据  － JSonString格式
@property(nonatomic, copy) NSString  *formStr;

@property(nonatomic, copy) NSString  *formId;


- (instancetype)initWithArray:(NSArray *)array;

//返回showFormModels已经整理好的
- (instancetype)initWithSortingArray:(NSArray *)array;

// 用于详情UI显示的
- (void)sortForUI;

- (void)sortForCreateUI;
@end

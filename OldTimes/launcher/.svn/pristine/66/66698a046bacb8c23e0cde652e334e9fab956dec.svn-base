//
//  SelectContactTabbarView.h
//  launcher
//
//  Created by williamzhang on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  选人底部栏 (所有属性贯穿选人控件)

#import <UIKit/UIKit.h>
#import "MyDefine.h"

@class ContactPersonDetailInformationModel, ContactDepartmentImformationModel;

@interface SelectContactTabbarView : UIView

/**
 *  选择的人员，当需要获取最新最近选人标准时，已此为标准(contactPersonDetailInfomationModel)
 */
@property (nonatomic, readonly) NSArray *arraySelected;

/** 所有的部门 */
@property (nonatomic, readonly) NSArray *arrayDepartments;

@property (nonatomic, assign  ) BOOL singleSelectable;
@property (nonatomic, assign  ) BOOL selfSelectable;

@property (nonatomic, readonly) NSDictionary *dictSelected;
@property (nonatomic, readonly) NSDictionary *dictUnableSelected;
@property (nonatomic) BOOL isMission;

/** 人员为ContactPersonDetailInfomationModel */
- (instancetype)initWithSelectPeople:(NSArray *)selectPeople unableSelectPeople:(NSArray *)unableSelectPeople completion:(void (^)(NSArray *))completion;
/**
 *  添加人员
 *
 *  @param person contactPersonDetailInfomationModel或者ContactDetailModel
 */
- (void)addOrDeletePerson:(id)person;

//全选或全删除
- (void)addOrDeleteDepartment:(ContactDepartmentImformationModel *)departmentModel contactsArray:(NSArray *)contactsArray;

/*
 *  数组中存ContactPersonDetailInformationModel
 */
- (void)deletePeople:(NSArray *)people;

@end

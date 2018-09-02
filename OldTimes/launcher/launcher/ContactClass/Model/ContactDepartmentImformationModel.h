//
//  ContactDepartmentImformationModel.h
//  launcher
//
//  Created by Conan Ma on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ContactDepartmentImformationModel : NSObject

@property (nonatomic, strong) NSString *ShowID;                   //子类部门id
@property (nonatomic, strong) NSString *D_NAME;                   //子类部门名
@property (nonatomic, strong) NSString *D_PARENT_NAME;            //上级部门名称,根部门为空---不知道用来干嘛，先存着
@property (nonatomic, strong) NSString *D_PARENTID_SHOW_ID;       //父类部门id 上级部门showID,根部门则为企业的showID
@property (nonatomic, strong) NSString *C_NAME;                   //所属企业名称
@property (nonatomic, strong) NSString *CREATE_USER_NAME;         //创建人姓名——没啥用
@property (nonatomic) NSInteger D_SORT;                           //排序号,越小排越前
@property (nonatomic) NSInteger D_AVAILABLE_COUNT;        //成员数

@property(nonatomic, assign) NSInteger  subObjCount;              //子类个数

@property (nonatomic,strong) NSNumber *_localId;        // 用于搜索
@property(nonatomic, copy) NSString  *keyStr;           //搜索的关键字

/** 属于该部门下的成员(key,value) = (userShowId,@1) */
@property (nonatomic, strong) NSDictionary *dictRelateContacts;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

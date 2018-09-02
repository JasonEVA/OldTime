//
//  ContactDepartmentImformationModel.m
//  launcher
//
//  Created by Conan Ma on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ContactDepartmentImformationModel.h"
#import "NSDictionary+SafeManager.h"

#define dict_ShowID @"SHOW_ID"                            //子类部门id
#define dict_D_NAME @"D_NAME"                             //子类部门名
#define dict_D_PARENT_NAME @"D_PARENT_NAME"               //上级部门名称,根部门为空---不知道用来干嘛，先存着
#define dict_D_PARENTID_SHOW_ID @"D_PARENTID_SHOW_ID"     //父类部门id 上级部门showID,根部门则为企业的showID
#define dict_C_NAME @"C_NAME"                             //所属企业名称
#define dict_CREATE_USER_NAME @"CREATE_USER_NAME"         //创建人姓名——没啥用
#define dict_D_SORT @"D_SORT"                             //排序号,越小排越前
#define dict_D_AVAILABLE_COUNT @"D_AVAILABLE_COUNT"        //成员数
@implementation ContactDepartmentImformationModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            self.ShowID = [dict valueStringForKey:dict_ShowID];
            self.D_NAME = [dict valueStringForKey:dict_D_NAME];
            self.D_PARENT_NAME = [dict valueStringForKey:dict_D_PARENT_NAME];
            self.D_PARENTID_SHOW_ID = [dict valueStringForKey:dict_D_PARENTID_SHOW_ID];
            self.C_NAME = [dict valueStringForKey:dict_C_NAME];
            self.CREATE_USER_NAME = [dict valueStringForKey:dict_CREATE_USER_NAME];
            self.D_SORT = [[dict valueNumberForKey:dict_C_NAME] integerValue];
            self.D_AVAILABLE_COUNT = [[dict valueNumberForKey:dict_D_AVAILABLE_COUNT] integerValue];
        }
    }
    return self;
}

@end

//
//  ContactBookGetUserListRequest.m
//  launcher
//
//  Created by kylehe on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//   ContactPersonDetailInformationModel

#import "ContactBookGetUserListRequest.h"
#import "ContactPersonDetailInformationModel.h"
#import "ContactBookMag.h"

static NSString * const User_deptId    = @"deptId";
static NSString * const User_SearchKey = @"searchKey";
static NSString * const User_currentPage = @"currentPage";
static NSString * const User_pageSize = @"pageSize";

@interface ContactBookGetUserListRequest ()

@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,strong) NSString * deptID;

@end

@implementation ContactBookGetUserListRequest

- (void)getUserWithDepartID:(NSString *)deptID withSearchKey:(NSString *)searchKey
{
    self.params[User_deptId] = deptID;
    self.params[User_SearchKey] = searchKey ;
    self.isSearch = YES;
    
    [self requestData];
}

- (void)getUserWithDepartID:(NSString *)deptID
{
    self.params[User_deptId] = deptID;
    self.deptID = deptID;
    [self requestData];
}

- (void)getUserWithSearchKey:(NSString *)searchKey
{
    self.params[User_SearchKey] = searchKey;
    self.params[User_pageSize] = @(self.pageSize);
    self.params[User_currentPage] = @(self.pageIndex);
    self.isSearch = YES;
    
    [self requestData];
}

- (NSString *)api
{
    return @"/Base-Module/CompanyUser/GetList";
}

- (NSString *)type
{
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ContactBookGetUserListResponce *response = [ContactBookGetUserListResponce new];
    NSMutableArray *array = [NSMutableArray array];
    
    if (!_isSearch) {
        [[ContactBookMag share] saveMemberData:data key:_deptID];
    }
    
    // 筛选重复人员
    NSMutableDictionary *dictExisted = [NSMutableDictionary dictionary];
    
    for (NSDictionary *dict in data) {
        if (!dict) {
            continue;
        }
        
        ContactPersonDetailInformationModel *model = [[ContactPersonDetailInformationModel alloc] initWithDict:dict];
        
        ContactPersonDetailInformationModel *existedModel = [dictExisted objectForKey:model.show_id];
        if (existedModel) {
            NSMutableArray *arrayTmp = [NSMutableArray arrayWithArray:existedModel.u_dept_id];
            [arrayTmp addObjectsFromArray:model.u_dept_id];
            existedModel.u_dept_id = [NSArray arrayWithArray:arrayTmp];
            
            arrayTmp = [NSMutableArray arrayWithArray:existedModel.d_name];
            [arrayTmp addObjectsFromArray:model.d_name];
            existedModel.d_name = [NSArray arrayWithArray:arrayTmp];
            
            arrayTmp = [NSMutableArray arrayWithArray:existedModel.d_parentid_show_id];
            [arrayTmp addObjectsFromArray:model.d_parentid_show_id];
            existedModel.d_parentid_show_id = [NSArray arrayWithArray:arrayTmp];
            
            arrayTmp = [NSMutableArray arrayWithArray:existedModel.d_path_name];
            [arrayTmp addObjectsFromArray:model.d_path_name];
            existedModel.d_path_name = [NSArray arrayWithArray:arrayTmp];
            
            continue;
        }
        
        [dictExisted setObject:model forKey:model.show_id];
        [array addObject:model];
    }
    response.modelArr = [NSMutableArray arrayWithArray:array];
    return  response;
}
@end

@implementation ContactBookGetUserListResponce

@end
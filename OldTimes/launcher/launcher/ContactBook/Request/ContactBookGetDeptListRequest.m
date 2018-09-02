//
//  ContactBookGetDeptListRequest.m
//  launcher
//
//  Created by kylehe on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookGetDeptListRequest.h"
#import "ContactDepartmentImformationModel.h"
#import "ContactBookMag.h"

static NSString * const ContactBook_ParentId = @"parentId";
static NSString * const ContactBook_searchKey = @"searchCompanyDeptName";
static NSString * const ContactBook_currentPage = @"currentPage";
static NSString * const ContactBook_pageSize = @"pageSize";

@interface ContactBookGetDeptListRequest ()

@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,strong) NSString * parentId;

@end

@implementation ContactBookGetDeptListRequest

- (NSString *)api
{
    return @"/Base-Module/CompanyDept/GetList";
}

- (NSString *)type
{
    return @"GET";
}

- (void)getCompanyDeptWithParentId:(NSString *)parentId
{
    self.params[ContactBook_ParentId] = parentId;
    self.parentId = parentId;
    [self requestData];
}
- (void)getCompanyDeptWithSearchKey:(NSString *)searchKey
{
    self.params[ContactBook_pageSize] = @(self.pageSize);
    self.params[ContactBook_currentPage] = @(self.pageIndex);
    self.params[ContactBook_searchKey] = searchKey;
    self.isSearch = YES;
    
    [self requestData];
    
}
- (BaseResponse *)prepareResponse:(id)data
{
    if (!_isSearch) {
        [[ContactBookMag share] saveBranchData:data key:_parentId];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    ContactBookGetDeptListResponse *response = [ContactBookGetDeptListResponse new];
    
    for (NSDictionary *personDict in data) {
        if (!personDict) {
            continue;
        }
        
        ContactDepartmentImformationModel *model = [[ContactDepartmentImformationModel alloc] initWithDict:personDict];
        [array addObject:model];
    }
    
    response.arrResult  = array;
    return response;
}

@end

@implementation ContactBookGetDeptListResponse

@end

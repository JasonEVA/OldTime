//
//  ContactBookGetDeptListRequest.h
//  launcher
//
//  Created by kylehe on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ContactBookGetDeptListResponse : BaseResponse

@property(nonatomic, strong) NSMutableArray  *arrResult;

@end

@interface ContactBookGetDeptListRequest : BaseRequest
- (void)getCompanyDeptWithParentId:(NSString *)parentId;
- (void)getCompanyDeptWithSearchKey:(NSString *)searchKey;
@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger pageIndex;
@end

//
//  ContactBookGetUserListRequest.h
//  launcher
//
//  Created by kylehe on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface ContactBookGetUserListResponce : BaseResponse

@property(nonatomic, strong) NSMutableArray  *modelArr;

@end

@interface ContactBookGetUserListRequest : BaseRequest

@property (nonatomic) NSInteger pageSize;
@property (nonatomic) NSInteger pageIndex;

- (void)getUserWithSearchKey:(NSString *)searchKey;

- (void)getUserWithDepartID:(NSString *)deptID;

- (void)getUserWithDepartID:(NSString *)deptID withSearchKey:(NSString *)searchKey;

@end

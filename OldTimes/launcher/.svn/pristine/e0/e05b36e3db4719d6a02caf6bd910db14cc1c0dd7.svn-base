//
//  ContactBookGetSortListRequest.m
//  launcher
//
//  Created by kylehe on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ContactBookGetSortListRequest.h"
#import "NSDictionary+SafeManager.h"

static NSString * SortList = @"SortList";

@implementation ContactBookGetSortListRequest

- (NSString *)api
{
    return @"/Base-Module/CompanyUser/GetSortList";
}

- (NSString *)type
{
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    NSArray *array  = nil;
    array = [data valueMutableArrayForKey:SortList];
    
    ContactBookGetSortListResponce *response =  [ContactBookGetSortListResponce new];
    response.sortArr  = array;
    return response;
}

@end

@implementation ContactBookGetSortListResponce

@end

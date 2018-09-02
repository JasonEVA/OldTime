//
//  RelationCheckCollectionReuqest.m
//  launcher
//
//  Created by kylehe on 16/4/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "RelationCheckCollectionReuqest.h"
#import "NSDictionary+SafeManager.h"

@implementation RelationCheckCollectionReuqest
- (NSString *)api
{
    return @"/Base-Module/CompanyUser/Exists";
}

- (NSString *)type
{
    return @"GET";
}

- (void)checkCollectionWithRelationName:(NSString *)relationName
{
    [self.params setValue:relationName forKey:@"showId"];
    
    [self requestData];
}



- (BaseResponse *)prepareResponse:(id)data
{
    RelationCheckCollectionResponse *response = [RelationCheckCollectionResponse new];
//    NSDictionary *dict = [data objectForKey:@"data"];
    response.isColleague = [data valueBoolForKey:@"exists"];
    return response;
}

@end

@implementation RelationCheckCollectionResponse


@end
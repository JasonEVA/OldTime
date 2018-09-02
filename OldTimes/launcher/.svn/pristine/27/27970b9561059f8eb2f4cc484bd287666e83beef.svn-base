//
//  ContactGetUserInformationRequest.m
//  launcher
//
//  Created by Conan Ma on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ContactGetUserInformationRequest.h"
#import "ContactPersonDetailInformationModel.h"

static NSString * const User_showId = @"showId";

@implementation ContactGetUserInformationResponse
@end

@implementation ContactGetUserInformationRequest

- (void)userShowID:(NSString *)showID {
    self.params[User_showId] = showID;
    [self requestData];
}

- (NSString *)api {
    return @"/Base-Module/CompanyUser";
}

- (NSString *)type {
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data {
    ContactGetUserInformationResponse *response = [ContactGetUserInformationResponse new];
    
    response.personModel = [[ContactPersonDetailInformationModel alloc] initWithDict:data];
    
    return response;
}

@end

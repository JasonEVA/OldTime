//
//  GetCompanyUserLoginUpdateRequest.m
//  launcher
//
//  Created by Simon on 8/11/16.
//  Copyright © 2016 William Zhang. All rights reserved.
//

#import "GetCompanyUserLoginUpdateRequest.h"
#import "NSDictionary+SafeManager.h"

const NSString * CurrentVersion = @"currentVersion";
const NSString * MobileTerminal = @"mobileTerminal";

@implementation GetCompanyUserLoginUpdateRequest
- (void)fetchAppUpdateInfo {

	NSString *currentVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
	self.params[CurrentVersion] = currentVersion;
	self.params[MobileTerminal] = @"ios";
	
	[self requestData];
}

- (NSString *)type {
	return @"GET";
}

- (NSString *)api {
	return @"/Base-Module/CompanyUserLogin/GetCompanyUserLoginUpdateType";
}

- (BaseResponse *)prepareResponse:(id)data {
	GetCompanyUserLoginUpdateResponse *response = [[GetCompanyUserLoginUpdateResponse alloc] init];
	NSInteger type = [[data valueNumberForKey:@"type"] integerValue];
	switch (type) {
		case 0:
			response.updateStrategy = AppUpdateNone;
			break;
			
		case 1:
			response.updateStrategy = AppUpdateNormal;
			break;
	
		case 2:
			response.updateStrategy = AppUpdateForce;
			break;
		default:
			response.updateStrategy = AppUpdateOhter;
			break;
	}
	
	response.version = [data valueStringForKey:@"version"];
	
	return response;
}

@end

@implementation GetCompanyUserLoginUpdateResponse

@end

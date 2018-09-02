//
//  GetCompanyUserLoginUpdateRequest.h
//  launcher
//
//  Created by Simon on 8/11/16.
//  Copyright © 2016 William Zhang. All rights reserved.
//

#import "BaseRequest.h"

@interface GetCompanyUserLoginUpdateRequest : BaseRequest
- (void)fetchAppUpdateInfo;

@end

typedef NS_ENUM(NSUInteger, AppUpdateStrategy) {
	AppUpdateNone = 0,
	AppUpdateNormal = 1,
	AppUpdateForce = 2,
	AppUpdateOhter,
};

@interface GetCompanyUserLoginUpdateResponse : BaseResponse

@property (nonatomic, assign) AppUpdateStrategy updateStrategy;
@property (nonatomic, copy) NSString *version;
@end

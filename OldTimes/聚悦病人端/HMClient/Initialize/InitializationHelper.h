//
//  InitializationHelper.h
//  HMClient
//
//  Created by yinquan on 17/1/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InitializeHelperDelegate.h"
#import "IMMessageHelper.h"

@interface InitializationHelper : NSObject

@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, weak) id<InitializeHelperDelegate> delegate;
@property (nonatomic, retain) NSString* teamIMGroupID;
@property (nonatomic, readonly) BOOL userHasService;

+ (InitializationHelper*) defaultHelper;
- (BOOL)userHasDispatchService;
- (void) startInitialize;

@end

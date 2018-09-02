//
//  HMViewControllerRouterHelper.h
//  HMClient
//
//  Created by yinquan on 16/10/14.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString* const kHMControllerScheme = @"jyhmclient";

@interface HMViewControllerRouterHelper : NSObject

+ (void) routerControllerWithUrlString:(NSString*) controllerUrlString;

@end

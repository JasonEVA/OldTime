//
//  RemoteNoticationHelper.h
//  HMClient
//
//  Created by yinqaun on 16/8/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteNoticationHelper : NSObject
{
    
}

@property (nonatomic, retain) NSString* notificationControllerName;
@property (nonatomic, retain) id controllerParam;

@property (nonatomic, retain) NSString* routerURLString;

- (void) setAlertInfo:(NSDictionary*) alertInfo;
- (void) gotoNotificationController;

+ (RemoteNoticationHelper*) defaultHelper;
@end

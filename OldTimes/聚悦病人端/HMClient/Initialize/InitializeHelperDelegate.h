//
//  InitializationHelperDelegate.h
//  HMClient
//
//  Created by yinquan on 17/1/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InitializeHelperDelegate <NSObject>

- (void) initializeError:(NSInteger) errorCode
                 Message:(NSString*) errMsg;

@end

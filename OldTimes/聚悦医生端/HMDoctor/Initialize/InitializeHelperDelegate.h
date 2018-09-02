//
//  InitializeHelperDelegate.h
//  HMDoctor
//
//  Created by yinquan on 17/1/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InitializeHelperDelegate <NSObject>

- (void) initializeError:(NSInteger) errorCode
                 Message:(NSString*) errMsg;

@end

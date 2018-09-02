//
//  InitializeHelper.h
//  HMDoctor
//
//  Created by yinquan on 17/1/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InitializeHelperDelegate.h"


@interface InitializeHelper : NSObject

@property (nonatomic, weak) id<InitializeHelperDelegate> delegate;

+ (InitializeHelper*) defaultHelper;

- (void) startInitialize;
@end

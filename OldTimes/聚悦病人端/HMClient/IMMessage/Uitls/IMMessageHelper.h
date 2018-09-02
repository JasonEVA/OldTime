//
//  IMMessageHelper.h
//  HMClient
//
//  Created by yinqaun on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface IMMessageHelper : NSObject

+ (IMMessageHelper*) defaultHelper;

- (void) addMessageDelegate:(id<MessageManagerDelegate>) delegate;
@end

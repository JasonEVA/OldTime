//
//  HttpTaskProgressDelegate.h
//  HMClient
//
//  Created by yinqaun on 16/6/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpTaskProgressDelegate <NSObject>

- (void) postPorgress:(NSInteger) postUnit Total:(NSInteger) totalUnit;
@end

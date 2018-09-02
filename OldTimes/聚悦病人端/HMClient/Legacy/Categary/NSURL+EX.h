//
//  NSURL+EX.h
//  HMClient
//
//  Created by Andrew Shen on 2016/10/26.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (EX)

// 将query转为dict
- (NSDictionary *)ats_convertURLQueryToDictionary;
@end

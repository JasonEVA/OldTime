//
//  HMSuperViseNLModel.h
//  HMClient
//
//  Created by jasonwang on 2017/6/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HMEachTestModel;
@interface HMSuperViseNLModel : NSObject
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSArray <HMEachTestModel *>*list;
@end

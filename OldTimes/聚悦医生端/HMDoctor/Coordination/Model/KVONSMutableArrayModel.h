//
//  KVONSMutableArrayModel.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//  KVO方式监听数组变化model

#import <Foundation/Foundation.h>

@interface KVONSMutableArrayModel : NSObject

@property(nonatomic, retain)NSMutableArray *modelArray;

-(id)initWithDic:(NSDictionary *)dic;

@end

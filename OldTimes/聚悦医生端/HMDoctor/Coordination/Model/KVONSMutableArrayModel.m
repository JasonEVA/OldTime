//
//  KVONSMutableArrayModel.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//  

#import "KVONSMutableArrayModel.h"

@implementation KVONSMutableArrayModel

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefine key ---%@",key);
}
@end

//
//  NSObject+JsonExtension.h
//  HMViewMgrDemo
//
//  Created by yinqaun on 16/3/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JsonExtension)

-(NSData*) objectJsonData;
-(NSString*) objectJsonString;

+ (id)JSONValue:(NSString*) json;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

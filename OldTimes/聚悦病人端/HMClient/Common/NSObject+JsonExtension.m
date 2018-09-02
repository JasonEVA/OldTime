//
//  NSObject+JsonExtension.m
//  HMViewMgrDemo
//
//  Created by yinqaun on 16/3/30.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NSObject+JsonExtension.h"

@implementation NSObject (JsonExtension)

-(NSData*) objectJsonData
{
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil)
        return nil;
    
    return result;
}

-(NSString*) objectJsonString
{
    NSData* jsonData = [self objectJsonData];
    if (jsonData)
    {
        NSString* jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

+ (id)JSONValue:(NSString*) json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if (error != nil) return nil;
    
    return result;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end

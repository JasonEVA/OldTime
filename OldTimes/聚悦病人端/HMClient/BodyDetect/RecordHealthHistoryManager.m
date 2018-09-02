//
//  RecordHealthHistoryManager.m
//  HMClient
//
//  Created by jasonwang on 2016/12/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "RecordHealthHistoryManager.h"

@implementation RecordHealthHistoryManager

+ (instancetype)sharedInstance {
    static RecordHealthHistoryManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RecordHealthHistoryManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)getFilePathString {
    UserInfo* curUser = [[UserInfoHelper defaultHelper] currentUserInfo];
    
    NSString *folder = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",curUser.userId]];
    
    NSString *filePath =  [folder stringByAppendingPathComponent:@"RecordsHealthHistory.plist"];
    NSLog(@"路径是：%@",filePath);
    return filePath;
}

- (void)saveWithHealthType:(NSString *)type number:(id)number{
    NSFileManager *fileManager = [NSFileManager defaultManager]; // default is not thread safe
    if (![fileManager fileExistsAtPath:[self getFilePathString]]) {
        if(![fileManager createFileAtPath:[self getFilePathString] contents:nil attributes:nil])
        {
            NSLog(@"create RecordsHealthHistory.plist error");
        }
        else {
            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:number,type ,nil];
            [dict writeToFile:[self getFilePathString] atomically:YES];
        }
    }
    else {
        NSMutableDictionary *mubDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getFilePathString]];
        [mubDict setObject:number forKey:type];
        [mubDict writeToFile:[self getFilePathString] atomically:YES];
    }

}

- (NSString *)getHealthTypeNumberWithType:(NSString *)type {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[self getFilePathString]];
    if ([dict[type] isKindOfClass:[NSString class]] && [dict[type] length]) {
        return dict[type];
    }
    else {
        return @"";
    }
}

- (NSArray *)getHealthTypeArrayWithType:(NSString *)type {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[self getFilePathString]];
    if ([dict[type] isKindOfClass:[NSArray class]] && [dict[type] count]) {
        return dict[type];
    }
    else {
        return @[];
    }
}
@end

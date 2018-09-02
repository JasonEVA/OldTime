//
//  MessageAppModel.m
//  launcher
//
//  Created by Andrew Shen on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MessageAppModel.h"
#import <MJExtension/MJExtension.h>
#import "IMApplicationManager.h"

@implementation MessageAppModel
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
    }
    
    if ([property.name isEqualToString:@"msgInfo"] && ![oldValue isKindOfClass:[NSString class]]) {
        oldValue = [oldValue mj_JSONString];
    }
    
    return oldValue;
}

- (NSDictionary *)applicationDetailDictionary {
    return [self.msgInfo mj_keyValues];
}

- (Msg_type)eventType {
    return [self getAppTypeFromShowID:self.msgAppShowID];
}

// 根据showID区分应用类型，得到应用类型枚举
- (Msg_type)getAppTypeFromShowID:(NSString *)showID {
    
    if (![showID hasSuffix:@"@APP"]) {
        showID = [showID stringByAppendingString:@"@APP"];
    }
    
    NSInteger type = [IMApplicationManager applicationTypeFromUid:showID];
    if (type == -1) {
        return msg_usefulMsgMin;
    }
    return type;
}

+ (NSString *)getShowIDfromAppType:(Msg_type)msgType
{
    NSString *showID = [IMApplicationManager applicaionUidFromType:msgType];
    if (!showID) {
        return nil;
    }
    
    return [showID stringByReplacingOccurrencesOfString:@"@APP" withString:@""];
}

// 是否是系统消息
- (BOOL)isAppSystemMessage
{
    if (_msgAppType != nil) {
        return self.msgType == 0;
    }
    return NO;
}

@end

//
//  ContactDetailModel.m
//  launcher
//
//  Created by William Zhang on 15/8/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ContactDetailModel.h"
#import "MessageBaseModel.h"
#import "NSDictionary+IMSafeManager.h"
#import "NSDate+IMManager.h"
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"
#import <MJExtension/MJExtension.h>
#import "ASJSONKitManager.h"
#import "NSString+Manager.h"
#import "IMApplicationManager.h"

#define WZ_INVISIBLE_IDENTIFIER @"\uFEFF\u200B"

@interface NSString (ContactDetailModel)

- (BOOL)wz_doseWrapInvisibleIdentifiers;

@end

NSString * const wz_image_type         = @"[图片]";
NSString * const wz_voice_type         = @"[语音]";
NSString * const wz_viedo_type         = @"[视频]";
NSString * const wz_file_type          = @"[文件]";
NSString * const wz_mergetForward_type = @"[聊天记录]";
NSString * const wz_voiceVoip_type     = @"[语音聊天]";
NSString * const wz_viedoVoip_type     = @"[视频聊天]";

@implementation ContactDetailModel



/** 判断是不是群聊
 */
+ (BOOL)isGroupWithTarget:(NSString *)target {
    return [target isContainsString:@"@ChatRoom"] || [target isContainsString:@"@SuperGroup"];
}

- (NSArray *)atUser {
    NSDictionary *infoDict = [self._info mj_JSONObject];
    NSArray *array = [infoDict im_valueArrayForKey:@"atUsers"];
    if (![array isKindOfClass:[NSArray class]]) {
        return @[];
    }
    return array;
}

- (BOOL)isAtMe {
    NSString *selfUid = [[MsgUserInfoMgr share] getUid];
    for (NSString *atUser in [self atUser]) {
        if ([atUser rangeOfString:selfUid].location != NSNotFound) {
            return YES;
        }
        
        if ([atUser length] > 3 && [[[atUser substringToIndex:3] uppercaseString] isEqualToString:@"ALL"]) {
            // 有atAll
            if (![[self getUid] isEqualToString:selfUid]) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSString *)getUid {
    NSDictionary *infoDict = [self._info mj_JSONObject];
    NSString *uid = [infoDict im_valueStringForKey:@"userName"];
    if (![uid isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return uid;
}

- (BOOL)verifyType:(Msg_type)type {
    if (![self._content wz_doseWrapInvisibleIdentifiers]) {
        return NO;
    }
    
    NSString *type_string = @"";
    switch (type) {
        case msg_personal_image: type_string = wz_image_type; break;
        case msg_personal_voice: type_string = wz_voice_type; break;
        case msg_personal_video: type_string = wz_viedo_type; break;
        case msg_personal_file: type_string = wz_file_type; break;
        case msg_personal_mergeMessage: type_string = wz_mergetForward_type; break;
            
        case msg_personal_voip: {
            return [self._content rangeOfString:wz_voiceVoip_type].location != NSNotFound ||
                   [self._content rangeOfString:wz_viedoVoip_type].location != NSNotFound;
        }
        
        default:
            return NO;
    }
    
    return [self._content rangeOfString:type_string].location != NSNotFound;
}

- (BOOL)isRelationSystem {
    return [self._target isEqualToString:MTRelationTarget];
}

@synthesize appModel = _appModel;
- (MessageAppModel *)appModel {
    if (!_appModel) {
        _appModel = [MessageAppModel mj_objectWithKeyValues:self._info];
    }
    return _appModel;
}

@end

@implementation NSString (ContactDetailModel)

- (BOOL)wz_doseWrapInvisibleIdentifiers {
    NSArray *array = [self componentsSeparatedByString:WZ_INVISIBLE_IDENTIFIER];
    return [array count] >= 2;
}

@end
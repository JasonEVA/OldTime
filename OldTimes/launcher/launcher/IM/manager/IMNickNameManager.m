//
//  IMNickNameManager.m
//  launcher
//
//  Created by williamzhang on 16/5/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "IMNickNameManager.h"
#import <MintcodeIM/MintcodeIM.h>

@interface IMNickNameManager ()

@property (nonatomic, strong) NSMutableDictionary *nickNameDict;

@end

@implementation IMNickNameManager

+ (IMNickNameManager *)share {
    static IMNickNameManager *shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    
    return shareInstance;
}

+ (NSString *)showNickNameWithOriginNickName:(NSString *)originNickName userId:(NSString *)userId {
    
    if (!userId || [userId length] == 0) {
        return originNickName;
    }
    
    NSString *showNickName = [self share].nickNameDict[userId];
    
    if (showNickName && [showNickName length] > 0) {
        return showNickName;
    }
    
    MessageRelationInfoModel *model = [[MessageManager share] queryRelationInfoWithUserID:userId];
    
    showNickName = originNickName;
    
    if (model && [model.remark length]) {
        showNickName = model.remark;
    }
    
    [self setNickName:showNickName forUserId:userId];
    
    return showNickName;
}

+ (void)setNickName:(NSString *)nickName forUserId:(NSString *)userId {
    [self share].nickNameDict[userId] = nickName;
}

- (NSMutableDictionary *)nickNameDict {
    if (!_nickNameDict) {
        _nickNameDict = [NSMutableDictionary dictionary];
    }
    return _nickNameDict;
}

@end

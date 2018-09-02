//
//  AvatarUtil.m
//  launcher
//
//  Created by williamzhang on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "AvatarUtil.h"
#import "UnifiedUserInfoManager.h"
#import <SDWebImage/SDWebImageManager.h>
#import <MintcodeIM/MintcodeIM.h>
#import "MyDefine.h"

static NSString * const avatarAPI = @"/Base-Module/Annex/Avatar?";

@interface avatarManager : NSObject

@property (nonatomic, strong) NSCache *avatarCache;

@end

@implementation avatarManager

+ (avatarManager *)share {
    static avatarManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[avatarManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _avatarCache = [[NSCache alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_avatarCache selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        _avatarCache.name = @"com.mintcode.avatarImageCache";
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

+ (NSString *)urlPathForKey:(NSString *)key {
    return [[self share].avatarCache objectForKey:key];
}

+ (void)setUrlPath:(NSString *)urlPath forKey:(NSString *)key {
    [[self share].avatarCache setObject:urlPath forKey:key];
}

+ (void)removeUrlPathForKey:(NSString *)key {
    [[self share].avatarCache removeObjectForKey:key];
}

@end

NSString *avatarSizeForType(avatarType type);

    NSString *avatarURLString(avatarType type, NSString *userShowId) {
    NSString *urlString = nil;
    NSString *key = [NSString stringWithFormat:@"%@_%@",userShowId, avatarSizeForType(type)];
    if ((urlString = [avatarManager urlPathForKey:key])) {
        return urlString;
    }
    
    NSString *urlSuffix = nil;
    // 先获取IM头像，没有则拼接
    UserProfileModel *user = [[MessageManager share] queryContactProfileWithUid:userShowId];
    if (user && [user.avatar length]) urlSuffix = user.avatar;
    
    if (!urlSuffix) {
        // 获取好友头像
        MessageRelationInfoModel *relation = [[MessageManager share] queryRelationInfoWithUserID:userShowId];
        if (relation && [relation.relationAvatar length]) urlSuffix = relation.relationAvatar;
    }
    
    if (urlSuffix) {
        urlString = [la_imgURLAddress stringByAppendingString:urlSuffix];
        urlString = [urlString stringByAppendingFormat:@"&%@=%@&%@=%@",
                     @"width", avatarSizeForType(type),
                     @"height", avatarSizeForType(type)];
        [avatarManager setUrlPath:urlString forKey:userShowId];
        return urlString;
    }
    
    // 拼接规则URL
    userShowId = userShowId ?: [UnifiedUserInfoManager share].userShowID;
    
    urlString = [la_imgURLAddress stringByAppendingString:avatarAPI];
    
    urlString = [urlString stringByAppendingFormat:@"%@=%@&%@=%@&%@=%@&%@=%@",
                 @"companyCode",[[UnifiedUserInfoManager share] companyCode],
                 @"userName",userShowId,
                 @"width",avatarSizeForType(type),
                 @"height",avatarSizeForType(type)];
    
    [avatarManager setUrlPath:urlString forKey:userShowId];
    
    return urlString;
}

NSURL *avatarURL(avatarType type, NSString *userShowId) {
    return [NSURL URLWithString:avatarURLString(type, userShowId)];
}

NSURL *avatarIMURL(avatarType type, NSString *fullPathSuffix) {
    if (![fullPathSuffix length]) return nil;
    NSString *urlString = [la_imgURLAddress stringByAppendingString:fullPathSuffix];
    urlString = [urlString stringByAppendingFormat:@"&%@=%@&%@=%@",
                 @"width", avatarSizeForType(type),
                 @"height", avatarSizeForType(type)];
    return [[NSURL alloc] initWithString:urlString];
}

void avatarRemoveCache(NSString *userShowId) {
    for (avatarType type = avatarType_default + 1; type <= avatarType_150; type ++) {
        NSString *urlString = avatarURLString(type, userShowId);
        [avatarManager removeUrlPathForKey:urlString];
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:urlString]];
        [[[SDWebImageManager sharedManager] imageCache] removeImageForKey:key];
    }
}

NSString *avatarSizeForType(avatarType type) {
    static NSDictionary *dict = nil;
    if (!dict) {
        dict = @{
                 @(avatarType_default):@"80",
                 @(avatarType_30):@"30",
                 @(avatarType_40):@"40",
                 @(avatarType_60):@"60",
                 @(avatarType_80):@"80",
                 @(avatarType_150):@"150"
                 };
    }
  
    return [dict objectForKey:@(type)];
}

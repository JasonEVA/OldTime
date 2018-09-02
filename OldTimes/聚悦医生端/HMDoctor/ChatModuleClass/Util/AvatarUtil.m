//
//  AvatarUtil.m
//  launcher
//
//  Created by williamzhang on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "AvatarUtil.h"
#import <SDWebImage/SDWebImageManager.h>
#import <MintcodeIMKit/MintcodeIMKit.h>
#import "MyDefine.h"
#import "ClientHelper.h"
static NSString * const avatarAPI = @"base.do?";

#define   AvatarBaseURL    [CommonFuncs picUrlPerfix]

@interface AvatarManager : NSObject

@property (nonatomic, strong) NSCache *avatarCache;

@end

@implementation AvatarManager

+ (AvatarManager *)share {
    static AvatarManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AvatarManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _avatarCache = [[NSCache alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_avatarCache selector:@selector(removeAllObjects) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeImageCache:) name:MTUserInfoChangeNotification object:nil];

        _avatarCache.name = @"com.mintcode.avatarImageCache";
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)removeImageCache:(NSNotification *)noti {
    if (!noti.object) {
        return;
    }
    NSLog(@"-------------->移除%@头像缓存",noti.object);
    avatarRemoveCache(noti.object);
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

#pragma mark - Private Method

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

NSString *avatarURLString(avatarType type, NSString *userShowId) {
    NSString *urlString = nil;
//    NSString *key = [NSString stringWithFormat:@"%@_%@",userShowId, avatarSizeForType(type)];
    NSString *key = [NSString stringWithFormat:@"%@",userShowId];
    if ((urlString = [AvatarManager urlPathForKey:key])) {
        return urlString;
    }
    
//    NSString *urlSuffix = nil;
//    // 先获取IM头像，没有则拼接
//    UserProfileModel *user = [[MessageManager share] queryContactProfileWithUid:userShowId];
//    if (user && [user.avatar length]) urlSuffix = user.avatar;
//    
//    if (!urlSuffix) {
//        // 获取好友头像
//        MessageRelationInfoModel *relation = [[MessageManager share] queryRelationInfoWithUserID:userShowId];
//        if (relation && [relation.relationAvatar length]) urlSuffix = relation.relationAvatar;
//    }
//    
//    if (urlSuffix) {
//        urlString = [kBaseUrl stringByAppendingString:urlSuffix];
//        if (!urlString) {
//            return @"";
//        }
//        [AvatarManager setUrlPath:urlString forKey:userShowId];
//        return urlString;
//    }
    // 拼接规则URL
    userShowId = userShowId;
    
    urlString = [kZJKBaseUrl stringByAppendingString:avatarAPI];
    // getUserImageDesc 获取缩略图 大小约30K
    // getUserImage     获取原图 大小约200K
    urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&%@=%@",@"method",@"getUserImageDesc",@"userId",userShowId]];
    if (!urlString) {
        return @"";
    }
    [AvatarManager setUrlPath:urlString forKey:userShowId];
    return urlString;
}

#pragma mark - Interface Method

NSURL *avatarURL(avatarType type, NSString *userShowId) {
    return [NSURL URLWithString:avatarURLString(type, userShowId)];
}

NSURL *avatarIMURL(avatarType type, NSString *fullPathSuffix) {
    if (![fullPathSuffix length]) return nil;
    NSString *urlString = [kZJKBaseUrl stringByAppendingString:fullPathSuffix];
    return [[NSURL alloc] initWithString:urlString];
}

void avatarRemoveCache(NSString *userShowId) {
    for (avatarType type = avatarType_default + 1; type <= avatarType_150; type ++) {
        NSString *urlString = avatarURLString(type, userShowId);
        [AvatarManager removeUrlPathForKey:urlString];
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:urlString]];
        [[[SDWebImageManager sharedManager] imageCache] removeImageForKey:key];
    }
}

@implementation AvatarUtil

+ (void)initAvatarManager {
    [AvatarManager share];
}

@end

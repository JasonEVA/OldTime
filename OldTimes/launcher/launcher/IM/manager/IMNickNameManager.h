//
//  IMNickNameManager.h
//  launcher
//
//  Created by williamzhang on 16/5/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMNickNameManager : NSObject

/**
 *  获取要显示的昵称或备注，备注优先
 *
 *  @param originNickName 昵称
 *  @param userId         用户Id
 *
 *  @return 待显示的字样
 */
+ (NSString *)showNickNameWithOriginNickName:(NSString *)originNickName userId:(NSString *)userId;

+ (void)setNickName:(NSString *)nickName forUserId:(NSString *)userId;

@end

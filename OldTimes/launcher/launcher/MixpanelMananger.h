//
//  MixpanelMananger.h
//  launcher
//
//  Created by williamzhang on 15/11/11.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixpanelMananger : NSObject

+ (void)installToken:(NSString *)token;

+ (void)track:(NSString *)track;
+ (void)track:(NSString *)track properties:(NSDictionary *)properties;

@end

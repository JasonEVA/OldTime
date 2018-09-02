//
//  UserProfileModel+Private.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/24.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <MintcodeIM/MintcodeIM.h>

@interface UserProfileModel (Private)

// 从字典里解析
- (instancetype)initWithDict:(NSDictionary *)dict;

@end

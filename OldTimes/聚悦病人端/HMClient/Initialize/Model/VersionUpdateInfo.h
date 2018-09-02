//
//  VersionUpdateInfo.h
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUpdateInfo : NSObject

@property (nonatomic, retain) NSString* upgradeVersion;     //内部版本号，用于判断是否需要升级
@property (nonatomic, retain) NSString* verAddr;
@property (nonatomic, retain) NSString* verCon;
@property (nonatomic, retain) NSString* verValue;


@end

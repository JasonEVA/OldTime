//
//  VersionUpdateInfo.h
//  HMDoctor
//
//  Created by yinquan on 16/4/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionUpdateInfo : NSObject

@property (nonatomic, retain) NSString* upgradeVersion;     //内部版本号，用于判断是否需要升级 
@property (nonatomic, retain) NSString* verAddr;
@property (nonatomic, retain) NSString* verCon;
@property (nonatomic, retain) NSString* verValue;
@end

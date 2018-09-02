//
//  MsgBaseDAL.h
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/12.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  网络基类

#import <Foundation/Foundation.h>
#import "SGdownloader.h"
#import "MsgDefine.h"

@interface MsgBaseDAL : NSObject

@property (nonatomic,strong) NSMutableDictionary *_dictInput;
@property (nonatomic,strong) NSDictionary *_dictOutput;
@property (nonatomic,strong) NSString *_message;
@property (nonatomic) NSInteger _code;
@property (nonatomic) NSInteger _remain;
@property (nonatomic) long long _msgId;
@property (nonatomic,strong) NSMutableArray *_arrMsg;      // 数据list
@property (nonatomic,strong) SGdownloader *_download;

/**
 *  判断是否2000
 *
 *  @return 只有2000返回YES
 */
- (BOOL)isSuccessCode;

@end

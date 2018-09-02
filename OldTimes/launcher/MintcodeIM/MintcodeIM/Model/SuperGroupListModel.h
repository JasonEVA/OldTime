//
//  SuperGroupListModel.h
//  MintcodeIM
//
//  Created by Dee on 16/6/27.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  群列表model

#import <Foundation/Foundation.h>

@interface SuperGroupListModel : NSObject
//用户最后一次更新时间
@property(nonatomic, assign) long long  modeified;
//用户名
@property(nonatomic, copy) NSString  *userName;
//头像
@property(nonatomic, copy) NSString  *avatar;
//用户类型
@property(nonatomic, copy) NSString  *type;
//昵称
@property(nonatomic, copy) NSString  *nickName;

@property(nonatomic, copy) NSString  *tag;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

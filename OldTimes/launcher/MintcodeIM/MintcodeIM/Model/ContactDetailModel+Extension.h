//
//  ContactDetailModel+Extension.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  扩展处理Model

#import "ContactDetailModel.h"

@interface ContactDetailModel (Extension)

/// 判断是不是从未读会话来的
@property (nonatomic, assign) BOOL _getFromUnReadList;

@end

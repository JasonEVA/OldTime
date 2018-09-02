//
//  TaskWhiteBoardModel.h
//  launcher
//
//  Created by William Zhang on 15/9/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  任务白板Model

#import <Foundation/Foundation.h>
#import "ProjectSearchDefine.h"

@interface TaskWhiteBoardModel : NSObject

@property (nonatomic, strong) NSString *showId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) whiteBoardStyle style;
/** 排序用的 */
@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, getter=isSelect) BOOL selected;

- (instancetype)initWithTitle:(NSString *)title;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

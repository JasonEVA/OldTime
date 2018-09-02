//
//  MissionSelectTagViewController.h
//  launcher
//
//  Created by William Zhang on 15/9/9.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  任务选择tag界面

#import "BaseViewController.h"

typedef void(^MissionSelectTagBlock)(NSArray *tagArray);


@interface MissionSelectTagViewController : BaseViewController

- (instancetype)initWithSelectTag:(MissionSelectTagBlock )selectBlock;

/** 已选择的tag */
- (void)selectedTags:(NSArray *)tags;

@end

//
//  NewEditingProjectViewController.h
//  launcher
//
//  Created by TabLiu on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
// 编辑项目

#import "BaseViewController.h"

typedef void(^delectBlock)();
typedef void(^changeProjectName)(NSString * name);

@interface NewEditingProjectViewController : BaseViewController

@property (nonatomic,strong) NSString * showId ;

- (void)setDeleProjectBlock:(delectBlock)block;
- (void)setChangeProjectName:(changeProjectName)changeBlock;

@end

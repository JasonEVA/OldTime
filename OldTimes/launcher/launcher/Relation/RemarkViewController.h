//
//  RemarkViewController.h
//  launcher
//
//  Created by TabLiu on 16/3/23.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  添加备注页面

#import "BaseViewController.h"

typedef void(^RemarkViewControllerBlock) (NSString * remark);

@interface RemarkViewController : BaseViewController

- (instancetype)initWithBlock:(RemarkViewControllerBlock)block define:(NSString *)str;

@end

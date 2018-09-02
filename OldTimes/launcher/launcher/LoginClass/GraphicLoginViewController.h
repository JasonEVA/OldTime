//
//  GraphicLoginViewController.h
//  launcher
//
//  Created by William Zhang on 15/7/28.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  手势登录界面

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, GraphicLoginViewController_Tag)
{
    tag_forget,
    tag_other
};

@interface GraphicLoginViewController : BaseViewController

//  PS:3DTouch点击进入解锁之后通知处理 其他地方没用到
- (void)setDismissBlock:(void (^)())dismissBlock;

/** 验证专用 */
@property (nonatomic, getter=isForVerify) BOOL verify;
- (void)setNotify;
@end

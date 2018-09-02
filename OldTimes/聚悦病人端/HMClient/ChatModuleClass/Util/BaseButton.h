//
//  BaseButton.h
//  launcher
//
//  Created by Lars Chen on 15/11/11.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天控件中的几个按钮

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, WZControlState) {
    WZControlStateNormal       = UIControlStateNormal,
    WZControlStateSelected     = UIControlStateSelected,                  // flag usable by app (see below)
};

@interface BaseButton : UIButton

/// 设置不同状态下的Image
- (void)wz_setImage:(UIImage *)image forState:(WZControlState)state;

@end

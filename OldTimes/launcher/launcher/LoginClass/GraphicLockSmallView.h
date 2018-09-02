//
//  GraphicLockSmallView.h
//  launcher
//
//  Created by William Zhang on 15/7/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  手势小🔒View

#import <UIKit/UIKit.h>

@interface GraphicLockSmallView : UIView

- (void)setPassword:(NSArray *)password;
- (void)setPassword:(NSArray *)password withIsSecond:(BOOL)issecond;

@end

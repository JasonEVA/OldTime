//
//  ApplyTableBar.h
//  launcher
//
//  Created by Kyle He on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  审核界面自定义的tabbar

#import <UIKit/UIKit.h>

@class ApplyTableBar;
@protocol ApplyTabBarDelegate <NSObject>
@optional
- (void)ApplytabBar:(ApplyTableBar *)tabBar CurrentSelectedIndex:(NSInteger)index;

@end

@interface ApplyTableBar : UIView

@property (nonatomic , weak) id <ApplyTabBarDelegate> delegate;

- (void)addTabeBarButtonWitItem:(UITabBarItem*)item;

- (void)setSelectedIndexWithTag:(int)tag;

@end

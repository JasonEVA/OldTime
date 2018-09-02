//
//  MainTabbarView.h
//  HMClient
//
//  Created by yinqaun on 16/4/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainTabbarMessageButton;
@protocol MainTabbarDelegate <NSObject>

- (void) tabbarSelected:(NSInteger) selectedIndex;
- (void)tabbarMainSelect;//中间tabbar点击事件
@end

@interface MainTabbarView : UIView
{
    
}

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<MainTabbarDelegate> delegate;
@property (nonatomic, strong) MainTabbarMessageButton* btnMessage;

- (void)showBadge:(NSUInteger)unreadMessageCount;
@end


@interface MainTabbarMessageButton : UIButton
{
    
}
@property (nonatomic, strong)  UILabel  *lbBadgeNumber; // 角标

- (void)showBadge:(NSUInteger)unreadMessageCount;
@end

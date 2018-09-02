//
//  HomeTabBarController.m
//  launcher
//
//  Created by William Zhang on 15/7/24.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "HomeTabBarController.h"
#import "BaseNavigationController.h"
#import "ChatViewController.h"
#import "ApplicationViewController.h"
#import "ContactBookViewController.h"
#import "MeMainViewController.h"
#import <MintcodeIM/MintcodeIM.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "Images.h"
#import "MixpanelMananger.h"

@interface HomeTabBarController () <BaseRequestDelegate>

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTab];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToMsgVC) name:MTWillShowSingleChatNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToMsgVC) name:MTWillShowGroupChatNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUnreadMsgCount) name:MTBadgeCountChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToAnother:) name:MTWillJumpTabbarToSubItemNotification object:nil];
    
    [self setUnreadMsgCount];
}

- (void)initTab
{
    self.tabBar.translucent = NO;
    
    NSArray *arrItemTitle = @[@"チャット", @"連絡先", @"アプリ", @"その他"];
  
    NSArray *arrItemImage         = @[IMG_TABBAR_CHAT_NORMAL, IMG_TABBAR_CONTACT_NORMAL, IMG_TABBAR_APPLICATION_NORMAL, IMG_TABBAR_ME_NORMAL];
    NSArray *arrItemSelectedImage = @[IMG_TABBAR_CHAT_SELECT, IMG_TABBAR_CONTACT_SELECT, IMG_TABBAR_APPLICATION_SELECT, IMG_TABBAR_ME_SELECT];

    NSMutableArray *arrTabBarItem = [NSMutableArray arrayWithCapacity:arrItemTitle.count];
    
    for (NSInteger i = 0; i < arrItemTitle.count; i ++)
    {
        UIImage *imageNormal = [[UIImage imageNamed:arrItemImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSelected = [[UIImage imageNamed:arrItemSelectedImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:arrItemTitle[i] image:imageNormal selectedImage:imageSelected];
        tabBarItem.tag = i;
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateSelected];
        [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor clearColor]} forState:UIControlStateNormal];
        
        [tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        
        [arrTabBarItem addObject:tabBarItem];
    }
    
    ChatViewController *chatVC = [[ChatViewController alloc] init];
//    [chatVC setTitle:arrItemTitle[0]];
    
    ContactBookViewController *contactVC = [[ContactBookViewController alloc] init];
//    [contactVC setTitle:arrItemTitle[1]];
    
    ApplicationViewController *appVC = [[ApplicationViewController alloc] init];
//    [appVC setTitle:arrItemTitle[2]];
    
    MeMainViewController *meVC = [[MeMainViewController alloc] init];
//    [meVC setTitle:arrItemTitle[3]];
    
    BaseNavigationController *chatNVC    = [[BaseNavigationController alloc] initWithRootViewController:chatVC];
    BaseNavigationController *contactNVC = [[BaseNavigationController alloc] initWithRootViewController:contactVC];
    BaseNavigationController *appNVC     = [[BaseNavigationController alloc] initWithRootViewController:appVC];
    BaseNavigationController *meNVC      = [[BaseNavigationController alloc] initWithRootViewController:meVC];
    
    chatNVC.tabBarItem    = arrTabBarItem[0];
    contactNVC.tabBarItem = arrTabBarItem[1];
    appNVC.tabBarItem     = arrTabBarItem[2];
    meNVC.tabBarItem      = arrTabBarItem[3];
    
    self.viewControllers = @[chatNVC, contactNVC, appNVC, meNVC];
}

#pragma mark - Private Method
- (void)jumpToMsgVC {
    [self setSelectedIndex:0];
}

- (void)setUnreadMsgCount {
    BaseNavigationController *chatNVC = [self.viewControllers firstObject];
    
    [[MessageManager share] queryAllUnreadMessageCountCompletion:^(NSInteger countUnreadMsg) {
        
        if (!chatNVC) {
            return;
        }
        
        if (countUnreadMsg > 0)
        {
            NSString *countString = [NSString stringWithFormat:@"%ld",countUnreadMsg];
            if (countUnreadMsg > 99) {
                countString = @"⋅⋅⋅";
            }
            [chatNVC.tabBarItem setBadgeValue:countString];
        }
        else
        {
            [chatNVC.tabBarItem setBadgeValue:nil];
        }
        
        // 增加AppIcon未读角标设置
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:countUnreadMsg];
    }];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index = [tabBar.items indexOfObject:item];
    if (index == 1) {
        [MixpanelMananger track:@"contacts"];
    }
    else if (index == 2) {
        [MixpanelMananger track:@"app center"];
    }
}

// 修改圆角未读数背景颜色
- (void)changeTabbarBadgeColor
{
    for (UIView* tabBarButton in self.tabBar.subviews) {
        for (UIView* badgeView in tabBarButton.subviews) {
            NSString* className = NSStringFromClass([badgeView class]);
            
            if ([className rangeOfString:@"BadgeView"].location != NSNotFound) {
                UILabel* badgeLabel;
                UIView* badgeBackground;
                
                for (UIView* badgeSubview in badgeView.subviews) {
                    NSString* className = NSStringFromClass([badgeSubview class]);
                    
                    if ([badgeSubview isKindOfClass:[UILabel class]]) {
                        badgeLabel = (UILabel *)badgeSubview;
                        
                    } else if ([className rangeOfString:@"BadgeBackground"].location != NSNotFound) {
                        badgeBackground = badgeSubview;
                    }
                }
                
                NSLog(@"font:%@",badgeLabel.font);
                NSLog(@"Size Height:%f,Width:%f",badgeView.frame.size.height,badgeView.frame.size.width);
                [badgeBackground setBackgroundColor:[UIColor themeRed]];
            }
        }
    }
}

// 跳转到第几页
- (void)jumpToAnother:(NSNotification *)notification
{
    [self dismissViewControllerAnimated:YES completion:nil];
    for (UINavigationController *navi in self.viewControllers) {
        [navi popToRootViewControllerAnimated:YES];
    }
    
    NSInteger index = [notification.object integerValue];
    if (index >= self.viewControllers.count)
    {
        return;
    }
    [self setSelectedIndex:index];
}

@end
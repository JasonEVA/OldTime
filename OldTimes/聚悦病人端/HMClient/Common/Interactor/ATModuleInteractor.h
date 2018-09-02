//
//  ATModuleInteractor.h
//  ArthasBaseAppStructure
//
//  Created by Andrew Shen on 16/2/26.
//  Copyright © 2016年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ATModuleInteractor : NSObject

+ (instancetype)sharedInstance;

// 普通push
- (void)pushToVC:(UIViewController *)VC;

// 强制跳转rootView再push
- (void)PushToChatVC:(UIViewController *)VC;

// 先pop掉firstVC 再push出secondVC （相当于用secondVC替换了firstVC）
- (void)popFirstVC:(UIViewController *)firstVC pushSecondVC:(UIViewController *)secondVC;

// pop到最外层后，在指定的TabBarSelectIndex上 push出pushVC
- (void)popToTabBarSelectIndex:(NSInteger)index pushVC:(UIViewController *)pushVC;
@end

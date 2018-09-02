//
//  NewMissionContainViewController.m
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewMissionContainViewController.h"
#import "NewMissionMainViewController.h"
#import "LiftTableViewViewController.h"
#import "BaseNavigationController.h"
#import "AnimationController.h"
@interface NewMissionContainViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, weak) LiftTableViewViewController *liftVC;
// 动画控制器
@property (nonatomic, strong)id<UIViewControllerAnimatedTransitioning> animationController;

@end

@implementation NewMissionContainViewController

- (instancetype)init {
    NewMissionMainViewController * centerVC = [[NewMissionMainViewController alloc] init];
    BaseNavigationController * centerNVC = [[BaseNavigationController alloc] initWithRootViewController:centerVC];
    [centerNVC setRestorationIdentifier:@"CentreViewControllerRestorationKey"];
    
    
    LiftTableViewViewController * liftVC = [[LiftTableViewViewController alloc] init];
    BaseNavigationController * liftNVC = [[BaseNavigationController alloc] initWithRootViewController:liftVC];
    [liftNVC setRestorationIdentifier:@"LiftViewControllerRestorationKey"];
    
    __weak typeof(centerVC) weakCenterVC = centerVC;
    __weak typeof(liftVC) weakLiftVC = liftVC;
    
    
    [liftVC setCellSelectForRowBlock:^(NSIndexPath *path, ProjectContentModel * model) {
        [weakCenterVC liftTableViewVC_ChangeSelectCellWithPath:path model:model];
    }];
    [liftVC setViewWillAppearBlock:^(BOOL isShow){
        [weakCenterVC drawerStart:isShow];
    }];
    
    [centerVC changeLeftVCSelectCellWithBlock:^(NSIndexPath *path, NSString *showId) {
        [weakLiftVC changeSelectCellWithPath:path showId:showId];
    }];
    
    self = [super initWithCenterViewController:centerNVC leftDrawerViewController:liftNVC];
    if (self) {
        self.liftVC = liftVC;
        [self setShowsShadow:NO];
        [self setRestorationIdentifier:@"MMDrawer"];
        [self setMaximumLeftDrawerWidth:LIFT_TABLEVIEW_WIDTH];
        [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    }
    self.animationController = [AnimationController new];
    return self;
}

- (void)presentedByViewController:(UIViewController *)viewController {
    self.transitioningDelegate = self;
    [viewController presentViewController:self animated:YES completion:nil];
}

- (void)selectAtIndex:(NSInteger)index {
    [self.liftVC selectAtIndex:index];
}

#pragma mark - UIViewControllerTransitioningDelegate
// 返回 present 动画控制器
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _animationController;
}

// 返回 dismiss 动画控制器
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _animationController;
}
@end
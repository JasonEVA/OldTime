//
//  AnimationController.m
//  launcher
//
//  Created by kylehe on 16/5/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "AnimationController.h"

@implementation AnimationController

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containterView = [transitionContext containerView];
    [containterView addSubview:toVc.view];
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVc];
    NSTimeInterval duration  = [self transitionDuration:transitionContext];
    
    if (toVc.isBeingPresented) {
        toVc.view.frame = CGRectOffset(finalFrame, finalFrame.size.width, 0);
        [UIView animateWithDuration:duration
                         animations:^{
                             toVc.view.frame = finalFrame;
                         }
                         completion:^(BOOL finished) {
                             // 结束后要通知系统
                             [transitionContext completeTransition:YES];
                         }];
    }

    if (fromVc.isBeingDismissed)
    {
        [containterView sendSubviewToBack:toVc.view];
        [UIView animateWithDuration:duration
                         animations:^{
                             fromVc.view.frame = CGRectOffset(finalFrame, finalFrame.size.width, 0);
                         }completion:^(BOOL finished) {
                             BOOL isComplete = ![transitionContext transitionWasCancelled];
                             [transitionContext completeTransition:isComplete];
                         }];
    }
}

@end

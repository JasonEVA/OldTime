//
//  UIView+ImageProgress.m
//  HMClient
//
//  Created by lkl on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UIView+ImageProgress.h"


@interface ImageProgressWaitView : UIView
{
    UIView* centerview;
}
@end

@implementation ImageProgressWaitView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
        CGRect rtCenter = CGRectMake(8.5, 8.5, 30, 30);
        centerview = [[UIView alloc] initWithFrame:rtCenter];
        NSLog(@"%f",self.width);
        
        [centerview.layer setCornerRadius:6];
        [self addSubview:centerview];
        [centerview setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
        
        UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [centerview addSubview:act];
        [act setLeft:(centerview.width - act.height)/2];
        [act setTop:(30 - act.height)/2];
        [act startAnimating];
        
    }
    return self;
}

@end



@implementation UIView (ImageProgress)

- (void) showImageWaitView
{
    UIView* waitview = [self viewWithTag:kZJKWaitViewTag];
    if (waitview)
    {
        return;
    }
    
    waitview = [[ImageProgressWaitView alloc]initWithFrame:self.bounds];
    [self addSubview:waitview];
    [waitview setTag:kZJKWaitViewTag];
    
}

- (void) closeImageWaitView
{
    UIView* waitview = [self viewWithTag:kZJKWaitViewTag];
    if (waitview)
    {
        [waitview removeFromSuperview];
    }
}




@end

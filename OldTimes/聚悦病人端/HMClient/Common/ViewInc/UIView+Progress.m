//
//  UIView+Progress.m
//  ZJKPatient
//
//  Created by yinqaun on 15/6/4.
//  Copyright (c) 2015年 YinQ. All rights reserved.
//

#import "UIView+Progress.h"
#import "UIView+SizeExtension.h"
#import "UIColor+HexExtension.h"


@interface ProgressWaitView : UIView
{
    UIView* centerview;
}
@end

@implementation ProgressWaitView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:0.33]];
        CGRect rtCenter = CGRectMake((self.width - 84)/2, (self.width - 84)/2, 84, 84);
        centerview = [[UIView alloc] initWithFrame:rtCenter];
        
        [centerview.layer setCornerRadius:6];
        [self addSubview:centerview];
        [centerview setBackgroundColor:[UIColor colorWithRed:0.34 green:0.34 blue:0.34 alpha:0.72]];
        
        UIActivityIndicatorView* act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [centerview addSubview:act];
        
        [act setLeft:(centerview.width - act.height)/2];
        [act setTop:(64 - act.height)/2];
        [act startAnimating];
        
        UILabel* lbText = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, centerview.width, 20)];
        [lbText setText:@"请等待..."];
        [centerview addSubview:lbText];
        [lbText setTextColor:[UIColor whiteColor]];
        [lbText setTextAlignment:NSTextAlignmentCenter];
        [lbText setFont:[UIFont font_26]];
        [lbText setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

@end



@implementation UIView (Progress)

- (void) showWaitView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD* progressHub = [window viewWithTag:kWXMImageProgressViewTag];
    if (progressHub)
    {
        return;
    }
    
    
    progressHub = [[MBProgressHUD alloc] initWithView:window];
    [window addSubview:progressHub];
    [window bringSubviewToFront:progressHub];
    //progressHub.delegate = self;
    progressHub.labelText = @"加载中...";
    [progressHub show:YES];
    [progressHub setTag:kWXMImageProgressViewTag];
    
}

- (void) showWaitView:(NSString*) content
{
    MBProgressHUD* progressHub = [self viewWithTag:kWXMImageProgressViewTag];
    if (progressHub)
    {
        progressHub.labelText = content;
        return;
    }
    progressHub = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:progressHub];
    [self bringSubviewToFront:progressHub];
    //progressHub.delegate = self;
    progressHub.labelText = content;
    [progressHub show:YES];
    [progressHub setTag:kWXMImageProgressViewTag];
}

- (void) closeWaitView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    MBProgressHUD* progressHub = [window viewWithTag:kWXMImageProgressViewTag];
    if (progressHub)
    {
        [progressHub removeFromSuperview];
        //[progressHub release];
        progressHub = nil;
    }
}


#if 0
- (void) showImageProgressView:(NSInteger) progress
{
    UIImageView* waitview = [self viewWithTag:kWXMImageProgressViewTag];
    if (!waitview)
    {
        waitview = [[UIImageView alloc]initWithFrame:self.bounds];
        [waitview setTag:kWXMImageProgressViewTag];
        [self addSubview:waitview];
    }
    
    //CGSize size = self.size;
    
    UIImage* imgProgress = [UIImage circleHollowImage:CGSizeMake(320, 320) Color:[UIColor colorWithRed:0.23 green:0.23 blue:0.23 alpha:0.86] Progress:progress];
    [waitview setImage:imgProgress];
    //[waitview setTag:kWXMImageProgressViewTag];
}
#endif

- (void) showImageProgressView:(NSInteger) progress
{
    MBProgressHUD* progressHub = [self viewWithTag:kWXMImageProgressViewTag];
    if (!progressHub)
    {
        progressHub = [[MBProgressHUD alloc] initWithView:self];
        [progressHub setMode:MBProgressHUDModeDeterminate];
        [self addSubview:progressHub];
        [self bringSubviewToFront:progressHub];
        
        [progressHub show:YES];
        
        [progressHub setTag:kWXMImageProgressViewTag];
    }

    //
    
    [progressHub setProgress:progress];
    
}

@end

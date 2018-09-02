//
//  Slacker.m
//  Parenting Strategy
//
//  Created by Remon Lv on 14-5-23.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "Slacker.h"
#import "MyDefine.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SystemSoundList.h"
#import "UnifiedUserInfoManager.h"

@implementation Slacker

// 计算UI的frame的x+width 或者y+height BOOL为真计算横向 否则计算纵向
+ (CGFloat)getValueWithFrame:(CGRect)rect WithX:(BOOL)remon
{
    return (remon ? (rect.origin.x + rect.size.width) : (rect.origin.y + rect.size.height));
}

// 移动UI
+ (void)moveUI:(UIView *)view ToPoint:(CGPoint)point Duration:(CGFloat)duration
{
    if (duration <= 0)
    {
        duration = 0.25;
    }
    [UIView animateWithDuration:duration animations:^{
        [view setCenter:point];
    }];
}

// 水波纹动画
+ (CATransition *)animationWaterWithDuration:(CGFloat)duration
{
    // 淡出效果
    CATransition *animation = [CATransition animation];
    //    animation.delegate = self;
    animation.duration = duration;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"rippleEffect"; // 波纹
    animation.subtype = kCATransitionFromLeft; // 对于波纹无意义
    return animation;
}

// 翻页动画
+ (void)animationFlipPageToNext:(BOOL)isNext Target:(UIView *)target
{
    UIViewAnimationTransition options;
    if (isNext)
    {
        options = UIViewAnimationTransitionCurlUp;
    }
    else
    {
        options = UIViewAnimationTransitionCurlDown;
    }
    
    [UIView animateWithDuration:0.8 animations:^{
        [UIView setAnimationTransition:options forView:target cache:YES];
    } completion:nil];
}

// 膨胀特效
+ (void)fadeInForTarget:(UIView *)target Scale:(CGSize)size Duration:(CGFloat)duration Alpha:(CGFloat)alpha
{
    target.transform = CGAffineTransformMakeScale(size.width, size.height);
    target.alpha = alpha;
    [UIView animateWithDuration:duration animations:^{
        target.alpha = 1;
        target.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

/* 这里要分享的是将image旋转，而不是将imageView旋转，原理就是使用quartz2D来画图片，然后使用ctm变幻来实现旋转。
 注：quartz2D的绘图左边和oc里面的绘图左边不一样，导致绘画出的图片是反转的。所以一上来得使它转正再进行进一步的旋转等 */
+ (UIImage *)convertImage:(UIImage *)image Rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

// 打印网络请求二进制结果码的方法
+ (void)printHttpPostResultWith:(NSData *)data
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",string);
}

/**
 *  获取View在自身坐标系的center
 *
 *  @param view 需要获取坐标的view
 *
 *  @return 相对于自身坐标系的中心点
 */
+ (CGPoint)getOwnBoundsCenterForView:(UIView *)view
{
    return CGPointMake(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5);
}

// ****************** 本App使用 ********************

// 结果码在8306的状态下自动注销
+ (void)loginOutAfterDuration
{
    // 延时发送注销
    [self performSelector:@selector(loginOut) withObject:nil afterDelay:3];
}

+ (void)loginOut
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TOKON_OUT object:nil];
}

#pragma mark - Frame & Screen Adapt

/**
 * 打印 Frame
 */
+ (NSString *)printFrame:(CGRect)frame WithMessage:(NSString *)msg
{
    NSString *log = [NSString stringWithFormat:@"%@ frame: (%.0f %.0f) <%.0f %.0f>", msg, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
    NSLog(@"%@", log);
    return log;
}

/**
 * 得到从小屏向大屏转换时候的 XMargin
 */
+ (CGFloat)getXMarginFrom320ToNowScreen
{
    return (IOS_SCREEN_WIDTH - 320) * 0.5;
}

/**
 * 得到从小屏向大屏转换时候的 YMargin
 */
+ (CGFloat)getYMarginFrom320ToNowScreen
{
    if (IOS_SCREEN_HEIGHT > 568)
    {
        return (IOS_SCREEN_HEIGHT - 568) * 0.5;
    }
    else
    {
        return 0;
    }
}

/**
 *  播放提示声音或者震动
 *
 *  @param kind 声音/震动/两者
 */
+ (void)playNotifySoundWithKind:(PlaySystemKind)kind
{
    switch (kind)
    {
        case system_shakeOnly:
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            break;
            
        case system_soundOnly:
            AudioServicesPlaySystemSound(SOUNDID);
            break;
            
        case system_soundAndShake:
            AudioServicesPlayAlertSound(SOUNDID);
            break;
            
        default:
            break;
    }
}

/**
 *  智能播放声效，并且智能区分配置表，定制使用
 */
+ (void)playNotifySoundIntellective
{
    // 查询配置表
    PlaySystemKind  playKind = (PlaySystemKind)[[UnifiedUserInfoManager share] getPlaySystemKindType];
    [self playNotifySoundWithKind:playKind];
}

//对图片尺寸进行压缩--
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);

    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

@end

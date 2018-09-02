//
//  NewMJRefreshGifHeader.m
//  launcher
//
//  Created by Lars Chen on 16/1/13.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  

#import "NewMJRefreshGifHeader.h"
#import "MyDefine.h"

@interface NewMJRefreshGifHeader ()

@property (weak, nonatomic) UIImageView *gifView;
/** 所有状态对应的动画图片 */
@property (strong, nonatomic) NSMutableDictionary *stateImages;
/** 所有状态对应的动画时间 */
@property (strong, nonatomic) NSMutableDictionary *stateDurations;

@end

@implementation NewMJRefreshGifHeader
#pragma mark - 懒加载
- (UIImageView *)gifView
{
    if (!_gifView) {
        UIImageView *gifView = [[UIImageView alloc] init];
        [self addSubview:_gifView = gifView];
    }
    return _gifView;
}

- (NSMutableDictionary *)stateImages
{
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

- (NSMutableDictionary *)stateDurations
{
    if (!_stateDurations) {
        self.stateDurations = [NSMutableDictionary dictionary];
    }
    return _stateDurations;
}

#pragma mark - 继承父类方法 实现动画更改
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
    CGPoint new = [change[@"new"] CGPointValue];
    if (new.y <= 0)
    {
        if (![self.gifView isAnimating])
        {
            NSArray *images = self.stateImages[@(MJRefreshStatePulling)];
            self.gifView.animationImages = images;
            self.gifView.animationDuration = [self.stateDurations[@(MJRefreshStatePulling)] doubleValue];
            [self.gifView startAnimating];
        }
        
        if (new.y == 0)
        {
            [self.gifView stopAnimating];
            
        }
        
        CGFloat circleHeight = 75;
        CGFloat originY = 0;
        if (self.state == MJRefreshStateIdle)
        {
            circleHeight = -new.y;
            originY = 75 + new.y;
        }
        if (circleHeight >= 55)
        {
            circleHeight = 55;
//            originY = new.y - 40;
        }
        [self.gifView setFrame:CGRectMake(IOS_SCREEN_WIDTH /2.0 - circleHeight / 2.0, originY + 10, circleHeight, circleHeight)];
    }
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    
    self.stateImages[@(state)] = images;
    self.stateDurations[@(state)] = @(duration);
    
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    // 停止动画
//    [self.gifView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.gifView.image = images[index];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
//    self.gifView.frame = self.bounds;
    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
        self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.gifView.contentMode = UIViewContentModeRight;
        self.gifView.mj_w = self.mj_w * 0.5 - 90;
    }
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        if (images.count == 0) return;
        
//        [self.gifView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.gifView.image = [images lastObject];
        } else { // 多张图片
//            self.gifView.animationImages = images;
//            self.gifView.animationDuration = [self.stateDurations[@(state)] doubleValue];
//            [self.gifView startAnimating];
        }
    }
}
@end

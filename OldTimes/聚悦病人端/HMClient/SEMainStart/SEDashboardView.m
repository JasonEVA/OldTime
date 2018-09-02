//
//  SEDashboardView.m
//  HMClient
//
//  Created by JasonWang on 2017/5/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SEDashboardView.h"
#import "SEDashboardPathLayer.h"

#define kPointerViewAnchorPoint CGPointMake(0.5, 0.95)

@interface SEDashboardView ()
@property (nonatomic, strong)  SEDashboardPathLayer  *pathLayer; // <##>
@property (nonatomic, assign)  CGFloat  backCircleAngle; // <##>
@end

@implementation SEDashboardView

+ (Class)layerClass {
    return [SEDashboardPathLayer class];
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.layer addSublayer:self.pathLayer];
    [self.pathLayer setNeedsDisplay];
    [self addSubview:self.pointerView];
    [self.pointerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_centerY).offset(3);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pathLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGPoint position = self.pointerView.layer.position;
    CGRect bounds = self.pointerView.bounds;
    self.pointerView.layer.position = CGPointMake((kPointerViewAnchorPoint.x - 0.5) * bounds.size.width + position.x, bounds.size.height * (kPointerViewAnchorPoint.y - 0.5) + position.y);
    [self.pointerView setTransform:CGAffineTransformMakeRotation(-self.backCircleAngle * 0.5)];
    
}

- (void)configCircleRadius:(CGFloat)circleRadius lineWidth:(CGFloat)lineWidth circleBGColcor:(UIColor *)circleBGColor highlightColor:(UIColor *)highlightColor  maskColor:(UIColor *)maskColor {
    [self.pathLayer configCircleRadius:circleRadius lineWidth:lineWidth circleBGColcor:circleBGColor highlightColor:highlightColor maskColor:maskColor];
}

- (void)configBackCircleAngle:(CGFloat)backCircleAngle highlightCircleAngle:(CGFloat)highlightCircleAngle {
    self.backCircleAngle = backCircleAngle;
    [self.pathLayer configBackCircleAngle:backCircleAngle highlightCircleAngle:highlightCircleAngle];
}

- (void)animatePointWithAngle:(CGFloat)angle {
    [self p_rotateViewAnimated:self.pointerView duration:1.5 angle:angle];
}


#pragma mark - Private

- (void)p_rotateViewAnimated:(UIView*)view
                    duration:(CFTimeInterval)duration
                       angle:(CGFloat)angle {
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    id fromAngle = @(-M_PI * 1.8 / 3);
    id toAngle = @(angle - M_PI * 2.25 / 3);
    rotationAnimation.fromValue = fromAngle;
    rotationAnimation.toValue = toAngle;
    rotationAnimation.duration = duration;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - init
- (UIImageView *)pointerView {
    if (!_pointerView) {
        _pointerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartgreen"] highlightedImage:[UIImage imageNamed:@"SEMainStartred"]];
        [_pointerView setUserInteractionEnabled:NO];
        self.pointerView.layer.anchorPoint = kPointerViewAnchorPoint;
        //        [self.pointerView setTransform:CGAffineTransformMakeRotation(-self.backCircleAngle * 0.5)];
        
    }
    return _pointerView;
}

- (SEDashboardPathLayer *)pathLayer {
    if (!_pathLayer) {
        _pathLayer = [SEDashboardPathLayer layer];
        _pathLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _pathLayer;
}


@end

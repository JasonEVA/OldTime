//
//  JWAnnularProgressView.m
//  HMClient
//
//  Created by jasonwang on 2017/8/9.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "JWAnnularProgressView.h"

@interface JWAnnularProgressView ()
@property (nonatomic, strong) UIColor *circularBackColor;
@property (nonatomic, strong) UIColor *circularProgressColor;
@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic) CGFloat circularWidth;
@property (nonatomic) CGFloat progress;
@property (nonatomic) CGFloat maxProgress;

@property (nonatomic, strong) CADisplayLink *displaylink;
@property (nonatomic, strong) CAShapeLayer *annularLayer;

@end

@implementation JWAnnularProgressView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame circularWidth:(CGFloat)circularWidth circularBackColor:(UIColor *)circularBackColor circularProgressColor:(UIColor *)circularProgressColor backColor:(UIColor *)backColor
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:backColor];
        self.circularWidth = circularWidth;
        self.circularBackColor = circularBackColor;
        self.circularProgressColor = circularProgressColor;
        self.backColor = backColor;
        [self.layer addSublayer:self.annularLayer];

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *pathBack = [UIBezierPath bezierPath];
    [pathBack addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:((self.frame.size.height - self.circularWidth) / 2) startAngle:1.5 * M_PI endAngle:3.5 * M_PI clockwise:YES];
    [pathBack setLineWidth:self.circularWidth];
    [self.circularBackColor setStroke];
    
    [self.backColor setFill];
    
    [pathBack stroke];

}

-(void)setCurrentAnnularLayerPath {
    
    UIBezierPath *progressPath = [UIBezierPath bezierPath];
    [progressPath addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:((self.frame.size.height - self.circularWidth) / 2) startAngle:1.5 * M_PI endAngle:(3.5 - 1.5) * M_PI * self.progress + 1.5 * M_PI clockwise:YES];
    self.annularLayer.path = progressPath.CGPath;
}
- (void)configAnnularWithProgress:(CGFloat)progress {
    //启动定时器
    
    self.progress = 0;
    self.maxProgress = progress;
    if (self.maxProgress <= 0) {
        [self setCurrentAnnularLayerPath];
        return;
    }
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [self.displaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

}

-(void)getCurrentWave:(CADisplayLink *)displayLink
{
    //实时的位移
    self.progress += 0.01;
    
    if (self.progress <= self.maxProgress + 0.01) {
        [self setCurrentAnnularLayerPath];
    }
    else {
        [self.displaylink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [self.displaylink invalidate];
        self.displaylink = nil;
        NSLog(@"CADisplayLink 销毁了");
    }
    
}


- (CAShapeLayer *)annularLayer {
    if (!_annularLayer) {
        _annularLayer = [CAShapeLayer layer];
        _annularLayer.strokeColor = self.circularProgressColor.CGColor;
        _annularLayer.lineWidth = self.circularWidth;
        _annularLayer.fillColor = self.backColor.CGColor;


    }
    return _annularLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

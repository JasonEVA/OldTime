//
//  GraphicLockView.m
//  launcher
//
//  Created by William Zhang on 15/7/28.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "GraphicLockView.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"
#import "UIColor+Hex.h"
static const CGFloat w_circle_response = 60;// 按钮直径
static const CGFloat w_circle = 65;

@interface GraphicLockView ()

/** 九个圈 */
@property (nonatomic, strong) NSMutableArray *arrayButton;
@property (nonatomic, strong) NSMutableArray *arraySelectedButton;
@property (nonatomic, strong) NSMutableArray *arrayPassword;
/** 当前👋位置 */
@property (nonatomic, assign) CGPoint currentPoint;

/** 是否在🎨 */
@property (nonatomic, assign) BOOL drawing;
/** 是否❌ */
@property (nonatomic, assign) BOOL isWrong;


@end

@implementation GraphicLockView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.arrayPassword       = [NSMutableArray array];
        self.arraySelectedButton = [NSMutableArray array];
        
        self.backgroundColor = [UIColor clearColor];
        // 防止超出父视图
        self.clipsToBounds = YES;
        
        [self initButtonFrame];
    }
    return self;
}

- (void)initButtonFrame
{
    for (UIButton *button in self.arrayButton)
    {
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(w_circle));
            switch ((button.tag % 3)) {
                case 0:
                    // 第一例
                    make.left.equalTo(self).offset(5);
                    break;
                case 1:
                    // 第二列
                    make.centerX.equalTo(self);
                    break;
                case 2:
                    make.right.equalTo(self).offset(-5);
                    break;
            }
            
            switch (button.tag / 3) {
                case 0:
                    make.top.equalTo(self).offset(5);
                    break;
                case 1:
                    make.centerY.equalTo(self);
                    break;
                case 2:
                    make.bottom.equalTo(self).offset(-5);
                    break;
            }
        }];
    }
}

#pragma mark - Private Method
- (void)updateFingerPosition:(CGPoint)point
{
    self.currentPoint = point;
    
    for (UIButton *button in self.arrayButton) {
        CGPoint center = CGPointMake(CGRectGetMinX(button.frame) + w_circle_response * 0.5, CGRectGetMinY(button.frame) + w_circle_response * 0.5);
        CGFloat xdiff = point.x - center.x;
        CGFloat ydiff = point.y - center.y;
        
        if (pow(xdiff, 2.0) + pow(ydiff, 2.0) - pow(w_circle_response, 2.0) * 0.25 < 0)
        {
            // 未选中加入
            if (!button.isSelected)
            {
                button.selected = YES;
                [self.arraySelectedButton addObject:button];
                [self.arrayPassword addObject:@(button.tag)];
            }
        }
    }
    
    [self setNeedsDisplay];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(GraphicLockViewDelegateCallBack_touchUpWithPassword:)])
    {
        [self.delegate GraphicLockViewDelegateCallBack_touchUpWithPassword:self.arrayPassword];
    }
}

- (void)endPosition
{
    NSString *string=@"";
    
    // 生成密码串
    for (NSInteger i = 0; i < self.arraySelectedButton.count; i++)
    {
        UIButton *button = self.arraySelectedButton[i];
        string= [string stringByAppendingFormat:@"%ld",(long)button.tag];
    }
    
    // 发送结果委托
    if ([self.delegate respondsToSelector:@selector(GraphicLockViewDelegateCallBack_finishWithPassword:)] && (self.arraySelectedButton.count != 0))
    {
        self.isWrong = [self.delegate GraphicLockViewDelegateCallBack_finishWithPassword:_arrayPassword];
    }
    
    // 错误则显示为红色
    if (self.isWrong)
    {
        for (UIButton* button in self.arrayButton)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"graphicPsw_wrong"] forState:UIControlStateSelected];
        }
    }
    
    [self setNeedsDisplay];
    //清除到初始样式
    [self performSelector:@selector(clearColorAndSelectedButton) withObject:nil afterDelay:self.isSecond? 1: 0];
    
    //清除到初始样式
//    [self clearColorAndSelectedButton];

}

// 清除至初始状态
- (void)clearColor
{
    // 重置颜色
    _isWrong = NO;
    for (UIButton* button in self.arrayButton)
    {
//        if (self.isSecond)
//        {
//            [button setBackgroundImage:[UIImage imageNamed:@"graphicPsw_selected_red"] forState:UIControlStateSelected];
//        }
//        else
//        {
            [button setBackgroundImage:[UIImage imageNamed:@"graphicPsw_selected"] forState:UIControlStateSelected];
//        }

    }
}

- (void)clearSelectedButton
{
    // 换到下次按时再弄
    for (UIButton *thisButton in self.arrayButton)
    {
        [thisButton setSelected:NO];
    }
    
    // 清空已选择的按钮
    [self.arraySelectedButton removeAllObjects];
    [self.arrayPassword removeAllObjects];
    [self setNeedsDisplay];
}

- (void)clearColorAndSelectedButton
{
    if (!self.drawing)
    {
        [self clearColor];
        [self clearSelectedButton];
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearColorAndSelectedButton) object:nil];
    [self clearColorAndSelectedButton];
    self.drawing = NO;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.drawing = YES;
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self updateFingerPosition:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.drawing = NO;
    [self endPosition];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.drawing = NO;
    [self endPosition];
}

- (void)drawRect:(CGRect)rect
{
    if (self.arraySelectedButton.count) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
//        if (self.isSecond)
//        {
//            self.isWrong ? [[UIColor redColor] set] : [[UIColor redColor] set]; // 正误线条色
//        }
//        else
//        {
            self.isWrong ? [[UIColor redColor] set] : [[UIColor whiteColor] set]; // 正误线条色
//        }
        CGContextSetLineWidth(context, 9);
        CGContextSetAlpha(context, 0.5);
        
        // 画之前线s
        CGPoint addLines[9];
        int count = 0;
        for (UIButton* button in self.arraySelectedButton)
        {
            CGPoint point = CGPointMake(button.center.x, button.center.y);
            addLines[count++] = point;
            
        }
        CGContextSetLineJoin(context, kCGLineJoinBevel);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextAddLines(context, addLines, count);
        CGContextStrokePath(context);
        
        if (self.drawing)
        {
            // 画当前线
            UIButton* lastButton = self.arraySelectedButton.lastObject;
            CGContextMoveToPoint(context, lastButton.center.x, lastButton.center.y);
            CGContextAddLineToPoint(context, _currentPoint.x, _currentPoint.y);
            CGContextStrokePath(context);
        }
    }
}

#pragma mark - Initializer
- (NSMutableArray *)arrayButton {
    if (!_arrayButton) {
        _arrayButton = [NSMutableArray array];
        for (NSInteger i = 0 ; i < 9; i ++) {
            UIButton *button = UIButton.new;

            [button setBackgroundImage:[UIImage imageNamed:@"graphicPsw_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"graphicPsw_selected"] forState:UIControlStateSelected];
            
            button.userInteractionEnabled = NO;
            button.tag = i;
            [_arrayButton addObject:button];
        }
    }
    return _arrayButton;
}

@end

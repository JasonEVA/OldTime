//
//  JWSegmentView.m
//  HMClient
//
//  Created by jasonwang on 2017/8/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "JWSegmentView.h"

@interface JWSegmentView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *btnArr;
@property (nonatomic, strong) UIView *moveLine;
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, copy) JWSegmentBlock block;

@property (nonatomic, strong) UIColor *titelSelectedJWColor;
@property (nonatomic, strong) UIColor *titelUnSelectedJWColor;
@property (nonatomic, strong) UIColor *lineJWColor;
@property (nonatomic, strong) UIColor *backJWColor;

@end

@implementation JWSegmentView

- (instancetype)initWithFrame:(CGRect)frame titelArr:(NSArray<NSString *> *)titelArr tagArr:(NSArray *)tagArr titelSelectedJWColor:(UIColor *)titelSelectedJWColor titelUnSelectedJWColor:(UIColor *)titelUnSelectedJWColor lineJWColor:(UIColor *)lineJWColor backJWColor:(UIColor *)backJWColor lineWidth:(CGFloat)lineWidth block:(JWSegmentBlock)block {
    if (self = [super initWithFrame:frame]) {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:backJWColor];
        self.titelSelectedJWColor = titelSelectedJWColor;
        self.titelUnSelectedJWColor = titelUnSelectedJWColor;
        self.lineJWColor = lineJWColor;
        UIView *line = [UIView new];
        [line setBackgroundColor:[UIColor colorWithHexString:@"ffffff"]];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
        if (titelArr && tagArr && titelArr.count && tagArr.count && tagArr.count == titelArr.count) {
            [titelArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = [UIButton new];
                [btn setTag:[tagArr[idx] integerValue]];
                [btn setTitle:obj forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
                [btn setTitleColor:idx?self.titelUnSelectedJWColor:self.titelSelectedJWColor forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self);
                    make.width.equalTo(@(self.frame.size.width/titelArr.count));
                    make.centerX.equalTo(self.mas_left).offset((frame.size.width / titelArr.count) * idx + (frame.size.width / (2 * titelArr.count)));
                }];
                [self.btnArr addObject:btn];
                
                if (!idx) {
                    self.selectBtn = btn;
                }
            }];
            
            [self addSubview:self.moveLine];
            
            [self.moveLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(line);
                make.height.equalTo(@3);
                make.width.equalTo(@(lineWidth));
                make.centerX.equalTo(self.mas_left).offset((frame.size.width / (2 * titelArr.count)));
            }];
        }
        
        self.block = block;
        
    }
    return self;
}

- (void)configSelectItemWithTag:(NSInteger)tag {
    __weak typeof(self) weakSelf = self;
    [self.btnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (obj.tag == tag) {
            [strongSelf configBtnWithBtn:obj];
        }
    }];
}

- (void)configBtnWithBtn:(UIButton *)btn {
    if (btn.tag == self.selectBtn.tag) {
        return;
    }
    [self.selectBtn setTitleColor:self.titelUnSelectedJWColor forState:UIControlStateNormal];
    
    NSInteger beforIdx = [self.btnArr indexOfObject:self.selectBtn];
    NSInteger afterIdx = [self.btnArr indexOfObject:btn];
    
    
    CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.duration = 0.2;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    NSValue * value1 = [NSValue valueWithCGPoint:CGPointMake((self.frame.size.width / self.btnArr.count) * beforIdx + (self.frame.size.width / (2 * self.btnArr.count)), self.frame.size.height - 1)];
    NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake((self.frame.size.width / self.btnArr.count) * afterIdx + (self.frame.size.width / (2 * self.btnArr.count)), self.frame.size.height - 1)];
    ani.values = @[value1, value2];
    [self.moveLine.layer addAnimation:ani forKey:@"PostionKeyframeValueAni"];
    
    self.selectBtn = btn;
    [self.selectBtn setTitleColor:self.titelSelectedJWColor forState:UIControlStateNormal];

}
- (void)btnClick:(UIButton *)btn {
    if (btn.tag == self.selectBtn.tag || self.isDisable) {
        return;
    }
    [self.selectBtn setTitleColor:self.titelUnSelectedJWColor forState:UIControlStateNormal];
    
    NSInteger beforIdx = [self.btnArr indexOfObject:self.selectBtn];
    NSInteger afterIdx = [self.btnArr indexOfObject:btn];

    
    CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.duration = 0.2;
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    NSValue * value1 = [NSValue valueWithCGPoint:CGPointMake((self.frame.size.width / self.btnArr.count) * beforIdx + (self.frame.size.width / (2 * self.btnArr.count)), self.frame.size.height - 1)];
    NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake((self.frame.size.width / self.btnArr.count) * afterIdx + (self.frame.size.width / (2 * self.btnArr.count)), self.frame.size.height - 1)];
    ani.values = @[value1, value2];
    [self.moveLine.layer addAnimation:ani forKey:@"PostionKeyframeValueAni"];
    
    self.selectBtn = btn;
    [self.selectBtn setTitleColor:self.titelSelectedJWColor forState:UIControlStateNormal];
    
    if (self.block) {
        self.block(self.selectBtn.tag);
    }
}

- (UIView *)moveLine {
    if (!_moveLine) {
        _moveLine = [UIView new];
        [_moveLine setBackgroundColor:self.lineJWColor];
    }
    return _moveLine;
}

- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

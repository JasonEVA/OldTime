//
//  RowButtonGroup.m
//  Shape
//
//  Created by Andrew Shen on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "RowButtonGroup.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"

@interface RowButtonGroup()

@property (nonatomic, strong)  NSMutableArray  *arrayBtn; // <##>
@property (nonatomic, strong)  UIView  *moveLine; // 移动的线
@end
@implementation RowButtonGroup

- (instancetype)initWithTitles:(NSArray *)arrayTitles tags:(NSArray *)arrayTags normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor font:(UIFont *)font lineColor:(UIColor *)lineColor {
    self = [super init];
    if (self) {
        // btn 个数
        NSInteger btnCount = arrayTitles.count;
        self.arrayBtn = [NSMutableArray arrayWithCapacity:btnCount];
        UIButton *btnLast;
        for (NSInteger i = 0; i < btnCount; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:arrayTitles[i] forState:UIControlStateNormal];
            [btn setTitleColor:normalTitleColor forState:UIControlStateNormal];
            [btn setTitleColor:selectedTitleColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSNumber *tag = arrayTags[i];
            [btn setTag:tag.integerValue];
            [btn.titleLabel setFont:font];
            if (i == 0) {
                [btn setSelected:YES];
                self.selectedBtn = btn;
                
            }
            [self addSubview:btn];
            [self.arrayBtn addObject:btn];

            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.top.equalTo(self);
                make.width.equalTo(self).multipliedBy(1.0 / btnCount);
                if (btnLast) {
                    make.left.equalTo(btnLast.mas_right);
                } else {
                    make.left.equalTo(self);
                }
                
            }];
            btnLast = btn;
            
        }
        
        UIView *lineBG = [UIView new];
        [lineBG setBackgroundColor:[UIColor borderColor]];
        [self addSubview:lineBG];
        [lineBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(1.0);
        }];
        // line
        _moveLine = [UIView new];
        [_moveLine setBackgroundColor:lineColor];
        [lineBG addSubview:_moveLine];

    }
    return self;
}


- (void)setBtnSelectedWithTag:(NSInteger)tag {
    UIButton *currentBtn = self.arrayBtn[tag];
    if (self.selectedBtn.tag != currentBtn.tag) {
        [self.selectedBtn setSelected:NO];
        [currentBtn setSelected:YES];
        self.selectedBtn = currentBtn;
        
        [self updateLineConstraints];
        if ([self.delegate respondsToSelector:@selector(RowButtonGroupDelegateCallBack_btnClickedWithTag:)]) {
            [self.delegate RowButtonGroupDelegateCallBack_btnClickedWithTag:self.selectedBtn.tag];
        }
    }

}

- (void)updateConstraints {
    [self.moveLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(1 / (CGFloat)self.arrayBtn.count);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1.5);
        make.centerX.equalTo(self.selectedBtn);
    }];

    [super updateConstraints];
}
- (void)btnClicked:(UIButton *)sender {
    if (self.selectedBtn.tag != sender.tag) {
        [self setBtnSelectedWithTag:sender.tag];
    }
}

#pragma mark - Private Method
- (void)updateLineConstraints {
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf layoutIfNeeded];
    }];
}
@end

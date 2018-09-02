//
//  RowButtonGroup.m
//  Shape
//
//  Created by Andrew Shen on 15/10/21.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "RowButtonGroup.h"
#import <Masonry/Masonry.h>

@interface RowButtonGroup()

@property (nonatomic, strong)  NSMutableArray  *arrayBtn; // <##>
@property (nonatomic, strong)  UIView  *moveLine; // 移动的线
@property (nonatomic, strong)  UIScrollView  *scrollView; // <##>
@end
@implementation RowButtonGroup

- (instancetype)initWithTitles:(NSArray *)arrayTitles tags:(NSArray *)arrayTags normalTitleColor:(UIColor *)normalTitleColor selectedTitleColor:(UIColor *)selectedTitleColor font:(UIFont *)font lineColor:(UIColor *)lineColor minimumButtonWidth:(CGFloat)minimumButtonWidth {
    self = [super init];
    if (self) {
        // btn 个数
        [self addSubview:self.scrollView];
        NSInteger btnCount = arrayTitles.count;
        self.arrayBtn = [NSMutableArray arrayWithCapacity:btnCount];
        UIButton *btnLast;
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
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
            [self.scrollView addSubview:btn];
            [self.arrayBtn addObject:btn];

            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.top.bottom.equalTo(self.scrollView);
                make.width.greaterThanOrEqualTo(@(minimumButtonWidth)).priorityHigh();
                make.width.equalTo(self).multipliedBy(1.0 / btnCount).priorityMedium();
                if (btnLast) {
                    make.left.equalTo(btnLast.mas_right);
                }
                else {
                    make.left.equalTo(self.scrollView);
                }
                
            }];
            btnLast = btn;
            
        }
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btnLast);
        }];

        UIView *lineBG = [UIView new];
        [lineBG setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [self.scrollView addSubview:lineBG];
        [lineBG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.scrollView);
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
    [self.scrollView scrollRectToVisible:currentBtn.frame animated:YES];
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

    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
@end

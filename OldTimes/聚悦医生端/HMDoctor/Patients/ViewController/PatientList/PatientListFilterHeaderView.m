//
//  PatientListFilterHeaderView.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientListFilterHeaderView.h"
#import "PatientFilterItem.h"

@interface PatientListFilterHeaderView ()
@property (nonatomic, strong)  NSMutableArray<UIButton *>  *buttonArray; // <##>
@property (nonatomic, copy)  PatientFilterItemClickedHandler  itemClickedHander; // <##>
@end
@implementation PatientListFilterHeaderView

- (instancetype)initWithTitles:(NSArray<NSString *> *)arrayTitles tags:(NSArray<NSNumber *> *)arrayTags {
    self = [super init];
    if (self) {
        // btn 个数
        NSInteger btnCount = arrayTitles.count;
        __block UIButton *btnLast;
        self.buttonArray = [NSMutableArray arrayWithCapacity:btnCount];
        __weak typeof(self) weakSelf = self;
        [arrayTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            PatientFilterItem *btn = [PatientFilterItem new];
            [btn.titleLabel setFont:[UIFont font_32]];
            [btn setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor mainThemeColor] forState:UIControlStateSelected];
            [btn setTitle:obj forState:UIControlStateNormal];
            [btn addTarget:strongSelf action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            NSNumber *tag = arrayTags ? arrayTags[idx] : @(idx);
            btn.tag = tag.integerValue;
            [strongSelf addSubview:btn];
            [strongSelf.buttonArray addObject:btn];
            
            [btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.top.bottom.equalTo(strongSelf);
                make.width.equalTo(strongSelf).multipliedBy(1.0 / btnCount);
                if (btnLast) {
                    make.left.equalTo(btnLast.mas_right);
                }
                else {
                    make.left.equalTo(strongSelf);
                }
                
            }];
            btnLast = btn;
            if (idx < btnCount - 1) {
                UIView *templeLine = [UIView new];
                templeLine.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
                [strongSelf addSubview:templeLine];
                [templeLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(btnLast.mas_right).offset(-0.5);
                    make.centerY.equalTo(strongSelf);
                    make.height.mas_equalTo(25);
                    make.width.mas_equalTo(0.5);
                }];
            }
        }];
    }
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    return self;
}

- (void)addNotyficationForItemClicked:(PatientFilterItemClickedHandler)block {
    self.itemClickedHander = block;
}

- (void)refreshTitleStateWithTitle:(NSString *)title {
    if (!self.selectedButton.selected) {
        return;
    }
    if (title.length > 0) {
        [self.selectedButton setTitle:title forState:UIControlStateNormal];
    }
    [self buttonClicked:self.selectedButton];
}

- (void)lockFilterButtonSelected:(BOOL)selected {
    PatientFilterItem *button = (PatientFilterItem *)self.buttonArray.lastObject;
    [button lockHighlight:selected];
    
}

#pragma mark - Event Method

- (void)buttonClicked:(UIButton *)sender {
    if (!self.selectedButton.selected) {
        sender.selected = YES;
        self.selectedButton = sender;
    }
    else {
        if (self.selectedButton.tag != sender.tag) {
            self.selectedButton.selected = NO;
            sender.selected = YES;
            self.selectedButton = sender;
        }
        else {
            self.selectedButton.selected = NO;
        }
    }
    if (self.itemClickedHander) {
        self.itemClickedHander(sender);
    }
}

@end

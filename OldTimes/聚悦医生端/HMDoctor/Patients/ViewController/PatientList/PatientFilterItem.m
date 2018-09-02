//
//  PatientFilterItem.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientFilterItem.h"

@interface PatientFilterItem ()
@property (nonatomic, strong)  UIImageView  *itemImageView; // <##>
@end

@implementation PatientFilterItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_configElements];
    }
    return self;
}

- (void)lockHighlight:(BOOL)highlight {
    if (highlight) {
        [self setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [self.itemImageView setImage:[UIImage imageNamed:@"patientList_arrow_selectedDown"]];
    }
    else {
        [self setTitleColor:[UIColor commonBlackTextColor_333333] forState:UIControlStateNormal];
        [self.itemImageView setImage:[UIImage imageNamed:@"patientList_arrow_normal"]];

    }
}


#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)p_configElements {
    
    // 设置数据
    [self p_configData];
    
    // 设置约束
    [self p_configConstraints];
}

// 设置数据
- (void)p_configData {
    
}

// 设置约束
- (void)p_configConstraints {
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -(self.itemImageView.size.width) * 0.5, 0, (self.itemImageView.size.width) * 0.5)];
    [self addSubview:self.itemImageView];
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right);
        make.right.lessThanOrEqualTo(self).offset(-2);
    }];
}


#pragma mark - Event Response

#pragma mark - Delegate

#pragma mark - Override

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.itemImageView.highlighted = selected;
}
#pragma mark - Init

- (UIImageView *)itemImageView {
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"patientList_arrow_normal"]];
        [_itemImageView setHighlightedImage:[UIImage imageNamed:@"patientList_arrow_selected"]];
    }
    return _itemImageView;
}

@end

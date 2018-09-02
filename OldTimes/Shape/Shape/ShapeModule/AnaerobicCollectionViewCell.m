//
//  AnaerobicCollectionViewCell.m
//  Shape
//
//  Created by Andrew Shen on 15/11/18.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AnaerobicCollectionViewCell.h"
#import "AnaerobicExerciseBodyView.h"
#import <Masonry/Masonry.h>

@interface AnaerobicCollectionViewCell()
@property (nonatomic, strong)  UIScrollView  *background; // <##>
@property (nonatomic, strong)  AnaerobicExerciseBodyView  *bodyView; // <##>
@end

@implementation AnaerobicCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.background];
        [self.background addSubview:self.bodyView];
        [self needsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [self.background mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.bodyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.background);
        make.height.equalTo(@([UIScreen mainScreen].bounds.size.width * 1.3));
    }];
    [self.background mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bodyView);
    }];

    [super updateConstraints];
}
- (void)configViewWithPositiveSide:(BOOL)positive {
    [self.bodyView configViewSide:positive];
}

- (UIScrollView *)background {
    if (!_background) {
        _background = [[UIScrollView alloc] init];
        _background.showsHorizontalScrollIndicator = NO;
        _background.showsVerticalScrollIndicator = NO;
        _background.bounces = NO;
    }
    return _background;
}

- (AnaerobicExerciseBodyView *)bodyView {
    if (!_bodyView) {
        _bodyView = [[AnaerobicExerciseBodyView alloc] init];
    }
    return _bodyView;
}
@end

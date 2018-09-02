//
//  AnaerobicExerciseView.m
//  Shape
//
//  Created by Andrew Shen on 15/10/22.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "AnaerobicExerciseView.h"
#import <Masonry/Masonry.h>
#import "RowButtonGroup.h"
#import "UIColor+Hex.h"
#import "UIStandardDefine.h"
#import "AnaerobicCollectionViewCell.h"

typedef enum : NSUInteger {
    tag_positive,
    tag_negative
} AerobicSideTag;

static NSString *const kCell = @"cell";

@interface AnaerobicExerciseView()<RowButtonGroupDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong)  RowButtonGroup  *rowBtnGroup; // 正反面按钮控件
@property (nonatomic, strong)  UIView  *lineOrange; // 按钮上的线
@property (nonatomic, strong)  UICollectionView  *collectionView; // 分页背景
@property (nonatomic, strong)  UIView  *shownView; // 当前显示的view

@end

@implementation AnaerobicExerciseView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

// 设置元素控件
- (void)configElements {
    
    [self addSubview:self.rowBtnGroup];
    [self.rowBtnGroup addSubview:self.lineOrange];
    [self addSubview:self.collectionView];
    
    [self needsUpdateConstraints];
}

- (void)updateConstraints {
    [self.rowBtnGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(height_40));
    }];
    
    [self.lineOrange mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@75);
        make.height.equalTo(@2);
        make.bottom.equalTo(self.rowBtnGroup);
        make.centerX.equalTo(self.rowBtnGroup.selectedBtn);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.rowBtnGroup.mas_bottom);
    }];
    [super updateConstraints];
}

#pragma mark - Private Method
- (void)updateCustomContraints {
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
    
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AnaerobicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
    if (indexPath.row == 0) {
        [cell configViewWithPositiveSide:YES];
    } else {
        [cell configViewWithPositiveSide:NO];
    }
    return cell;
        
}


#pragma mark - rowBtnGroupDelegate
// 正反面点击委托
- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    [self updateCustomContraints];
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x - self.frame.size.width * 0.5) / self.frame.size.width + 1;
    AerobicSideTag tag = (AerobicSideTag)currentIndex;
    [self.rowBtnGroup setBtnSelectedWithTag:tag];

}
#pragma mark - Init
- (RowButtonGroup *)rowBtnGroup {
    if (!_rowBtnGroup) {
        _rowBtnGroup = [[RowButtonGroup alloc] initWithTitles:@[@"正面",@"反面"] tags:@[@(tag_positive),@(tag_negative)] normalTitleColor:[UIColor colorLightGray_898888] selectedTitleColor:[UIColor themeOrange_ff5d2b] font:[UIFont systemFontOfSize:fontSize_15]];
        [_rowBtnGroup setDelegate:self];
        [_rowBtnGroup setBackgroundColor:[UIColor themeBackground_373737]];
    }
    return _rowBtnGroup;
}

- (UIView *)lineOrange {
    if (!_lineOrange) {
        _lineOrange = [[UIView alloc] init];
        [_lineOrange setBackgroundColor:[UIColor themeOrange_ff5d2b]];
    }
    return _lineOrange;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - 70 - 84);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [layout setSectionInset:UIEdgeInsetsZero];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[AnaerobicCollectionViewCell class] forCellWithReuseIdentifier:kCell];
        
        [_collectionView setPagingEnabled:YES];
        [_collectionView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        
    }
    return _collectionView;
}

@end

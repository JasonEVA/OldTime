//
//  HealthCenterStartHeaderView.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterStartHeaderView.h"
#import "RowButtonGroup.h"
#import "HealthCenterMonitorTypeCollectionViewCell.h"


typedef NS_ENUM(NSUInteger, HealthMonitorCategoryTag) {
    HealthMonitorBloodPressure,
    HealthMonitorHeartRate,
    HealthMonitorWeight,
    HealthMonitorBloodSugar,
    HealthMonitorBloodFat,
    HealthMonitor,
};

@interface HealthCenterStartHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource,RowButtonGroupDelegate>
@property (nonatomic, strong) RowButtonGroup   *btnGroup; // <##>
@property (nonatomic, strong)  UICollectionView  *collectionView; // 卡片
@property (nonatomic, copy)  NSArray  *categoryTitles; // <##>
@end

@implementation HealthCenterStartHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configElements];
    }
    return self;
}

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self addSubview:self.btnGroup];
    [self addSubview:self.collectionView];
    
    [self.btnGroup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(45);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.btnGroup.mas_bottom);
    }];

}

// 设置数据
- (void)configData {
    
    
}
#pragma mark - Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categoryTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        HealthCenterMonitorTypeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HealthCenterMonitorTypeCollectionViewCell at_identifier] forIndexPath:indexPath];
        return cell;
    }
    else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UICollectionViewCell at_identifier] forIndexPath:indexPath];
        cell.backgroundColor = [UIColor commonBackgroundColor];
        cell.backgroundView = ({
            UILabel *lb = [UILabel new];
            lb.textColor = [UIColor commonTextColor];
            lb.font = [UIFont systemFontOfSize:25];
            lb.text = @"未测量";
            lb.textAlignment = NSTextAlignmentCenter;
            lb;
        });
        return cell;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = (scrollView.contentOffset.x - self.frame.size.width * 0.5) / self.frame.size.width + 1;
    [self.btnGroup setBtnSelectedWithTag:currentIndex];
}

#pragma mark - RowButtonGroupDelegate

- (void)RowButtonGroupDelegateCallBack_btnClickedWithTag:(NSInteger)tag {
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - Init 

- (RowButtonGroup *)btnGroup {
    if (!_btnGroup) {
        _btnGroup = [[RowButtonGroup alloc] initWithTitles:self.categoryTitles tags:@[@(HealthMonitorBloodPressure),@(HealthMonitorHeartRate),@(HealthMonitorWeight),@(HealthMonitorBloodSugar),@(HealthMonitorBloodFat),@(HealthMonitor)] normalTitleColor:[UIColor commonGrayTextColor] selectedTitleColor:[UIColor mainThemeColor] font:[UIFont font_28] lineColor:[UIColor mainThemeColor] minimumButtonWidth:75];
        _btnGroup.delegate = self;
    }
    return _btnGroup;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - 45);
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[HealthCenterMonitorTypeCollectionViewCell class] forCellWithReuseIdentifier:[HealthCenterMonitorTypeCollectionViewCell at_identifier]];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[UICollectionViewCell at_identifier]];

        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (NSArray *)categoryTitles {
    if (!_categoryTitles) {
        _categoryTitles = @[@"血压",@"心率",@"体重",@"血糖",@"血脂",@"其他"];
    }
    return _categoryTitles;
}

@end

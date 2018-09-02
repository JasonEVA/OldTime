//
//  WeekColumnView.m
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "WeekColumnView.h"
#import "CalendarDayCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "DateUtil.h"

static NSString *const kIdentifier = @"dayCell";
static NSInteger const kColumn = 7;

@interface WeekColumnView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong)  UICollectionView  *collectionView; // <##>
@property (nonatomic, strong)  NSMutableArray  *dataSource; // <##>
@property (nonatomic)  NSInteger  todayIndex; // 今天是第几个
@end
@implementation WeekColumnView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        [self configElements];
    }
    return self;
}

// 设置元素控件
- (void)configElements {
    NSArray *titles = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    UILabel *lastlb;
    for (NSInteger i = 0; i < kColumn; i ++) {
        UILabel *lb = [[UILabel alloc] init];
        [lb setText:titles[i]];
        [lb setFont:[UIFont systemFontOfSize:15]];
        [lb setTextColor:[UIColor colorLightGray_989898]];

        [lb setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:lb];
        CGFloat lbWidth = self.frame.size.width / kColumn;
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.left.equalTo(self).offset(i * lbWidth);
            make.width.equalTo(@(lbWidth));
        }];
        lastlb = lb;
    }
    [self addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastlb.mas_bottom).offset(2);
        make.left.right.bottom.equalTo(self);
    }];
    
    // 初始化时间
    [self getThisWeekDate];
}

// 获得本周时间
- (void)getThisWeekDate {
    
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:kColumn];
    NSDateComponents *comp = [DateUtil dateComponentsForDate:[NSDate date]];
    for (NSInteger i = 1 - comp.weekday; i <= kColumn - comp.weekday; i ++) {
        NSDate *date = [DateUtil dateFromDate:[NSDate date] intervalDay:i ];
        NSDateComponents *compTemp = [DateUtil dateComponentsForDate:date];
        [arrayTemp addObject:@(compTemp.day)];
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:arrayTemp];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:comp.weekday - 1 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];

}
#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CalendarDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifier forIndexPath:indexPath];
    
    NSNumber *day = self.dataSource[indexPath.row];
    [cell setTitleDay:[NSString stringWithFormat:@"%ld",day.integerValue]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(WeekColumnViewDelegateCallBack_weekDayClicked:)]) {
        [self.delegate WeekColumnViewDelegateCallBack_weekDayClicked:indexPath.row];
    }
}

#pragma mark - Init
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(30,30);
        CGFloat spacing = (self.frame.size.width - 30 * kColumn) / kColumn;
        layout.minimumLineSpacing = spacing;
//        layout.minimumInteritemSpacing = spacing;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [layout setSectionInset:UIEdgeInsetsMake(5, spacing * 0.5, 5, spacing * 0.5)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[CalendarDayCollectionViewCell class] forCellWithReuseIdentifier:kIdentifier];
        [_collectionView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];

    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    }
    return _dataSource;
}
@end

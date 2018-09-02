//
//  HMWeeklySelectDateView.m
//  HMClient
//
//  Created by JasonWang on 2017/5/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeeklySelectDateView.h"
#import "HMDateSelectCollectionViewCell.h"

#define WEEKWIDTH   ([UIScreen mainScreen].bounds.size.width / 7)

#define OFFSETWEEKS       5
#define OFFSETDAYS        (OFFSETWEEKS * 7)

#define VIEWHEIGHT      120

@interface HMWeeklySelectDateView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *weekCollectView;
@property (nonatomic, strong) UICollectionView *dateCollectView;
@property (nonatomic, strong) NSMutableArray <NSDate *>*dateDataList;  // 日期数据源
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic) CGFloat contentWidth;

@property (nonatomic, copy) HMWeeklySelectedDateBlock block;
@property (nonatomic, strong) UIButton *backTodayBtn;
@end

@implementation HMWeeklySelectDateView

- (instancetype)initWithStartDate:(NSDate *)startDate {
    if (self = [super init]) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"3cd395"] CGColor], (__bridge id)[[UIColor colorWithHexString:@"31c9ba"] CGColor]];
        gradientLayer.locations = @[@0.4, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 1.0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, VIEWHEIGHT);
        [self.layer addSublayer:gradientLayer];
        
        [self addSubview:self.backTodayBtn];
        [self.backTodayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(7.5);
            make.top.equalTo(self);
            make.height.equalTo(@30);
            make.width.equalTo(@50);
        }];

        [self addSubview:self.weekCollectView];
        [self.weekCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.backTodayBtn.mas_bottom).offset(5);
            make.height.equalTo(@25);
        }];
        
        [self addSubview:self.dateCollectView];
        [self.dateCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.weekCollectView.mas_bottom).offset(5);
            make.left.right.equalTo(self.weekCollectView);
            make.height.equalTo(@45);
        }];
        
//        self.startDate = [NSDate date];
        self.selectedDate = startDate;
         [self performSelector:@selector(scrollMiddle) withObject:nil afterDelay:0.5];
        
    }
    return self;
}
#pragma mark -private method
- (void)configElements {
}

- (void)configDataList {
    
}

- (BOOL)isSunday:(NSDate *)date {
    if ([date weekday] == 1) {
        return YES;
    }
    return NO;
}

- (BOOL)isSaturday:(NSDate *)date {
    if ([date weekday] == 7) {
        return YES;
    }
    return NO;
}


// collectionView下一批
- (void)addNextBatchData
{
    
    
    // 插入开始日期后的数组
    NSDate *tempDate = self.dateDataList.lastObject;
    for (int i = 1; i <= OFFSETDAYS; i++) {
        [_dateDataList addObject:[tempDate dateByAddingDays:i]];
    }
    
    self.contentWidth = self.dateDataList.count * WEEKWIDTH;
    
    [self performSelector:@selector(scrollNext) withObject:nil afterDelay:0.00001];

    [self.dateCollectView reloadData];
    
}

// collectionView上一批
- (void)addLastBatchData
{
    // 插入开始日期前的数组
    NSDate *tempDate = self.dateDataList.firstObject;

    for (int i = 1; i <= OFFSETDAYS; i++) {
        [_dateDataList insertObject:[tempDate dateBySubtractingDays:i] atIndex:0];
    }
    
    self.contentWidth = self.dateDataList.count * WEEKWIDTH;


    [self performSelector:@selector(scrollLast) withObject:nil afterDelay:0.00001];

    [self.dateCollectView reloadData];
   
}

- (void)scrollLast {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:OFFSETDAYS - 7 inSection:0];
    
    [self.dateCollectView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)scrollNext {
    [self.dateCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dateDataList.count - OFFSETDAYS inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)scrollMiddle {
    [self.dateCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dateDataList.count / 2 - 3 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)scrollSomeDay:(NSDate *)date {
    __block NSInteger tempIndex = 0;
    [self.dateDataList enumerateObjectsUsingBlock:^(NSDate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([date isSameDay:obj]) {
            tempIndex = idx;
        }
    }];
    
    [self.dateCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:tempIndex - date.weekday + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)updateSelectedDate:(NSDate *)date {
    self.selectedDate = date;
    [self.dateCollectView reloadData];

    if (self.block) {
        self.block(self.selectedDate);
    }

}

#pragma mark - event Response
- (void)backTodayClick {
    if ([self.selectedDate isToday]) {
        return;
    }
    self.selectedDate = [NSDate date];
    [self performSelector:@selector(scrollSomeDay:) withObject:[NSDate date] afterDelay:0.00001];
    [self.dateCollectView reloadData];

    if (self.block) {
        self.block(self.selectedDate);
    }
}
#pragma mark - Delegate

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.weekCollectView]) {
        return 7;
    }
    else {
        return self.dateDataList.count;
    }
}

//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.weekCollectView]) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UICollectionViewCell at_identifier] forIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor clearColor]];
        UILabel *weekLb = [UILabel new];
        [weekLb setBackgroundColor:[UIColor clearColor]];
        [weekLb setTextColor:[UIColor whiteColor]];
        [weekLb setFont:[UIFont systemFontOfSize:14]];
        [weekLb setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:weekLb];
        [weekLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
        NSString *tempString = @"";
        if (indexPath.row == 0) {
            tempString = @"日";
        }
        else if (indexPath.row == 1) {
            tempString = @"一";
        }
        else if (indexPath.row == 2) {
            tempString = @"二";
        }
        else if (indexPath.row == 3) {
            tempString = @"三";
        }
        else if (indexPath.row == 4) {
            tempString = @"四";
        }
        else if (indexPath.row == 5) {
            tempString = @"五";
        }
        else if (indexPath.row == 6) {
            tempString = @"六";
        }
        
        [weekLb setText:tempString];

        return cell;
        
    }
    else {
        NSDate *tempDate = self.dateDataList[indexPath.row];
        HMDateSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMDateSelectCollectionViewCell at_identifier] forIndexPath:indexPath];
        [cell fillDataWithDate:tempDate];
        [cell.monthLb setHidden:indexPath.row % 7 != 0];
        if ([tempDate daysFrom:[NSDate date]] < 0) {
            [cell.dayBtn.titleLabel setAlpha:0.5];
        }
        else {
            [cell.dayBtn.titleLabel setAlpha:1];
        }
        [cell.dayBtn setSelected:[self.selectedDate isSameDay:tempDate]];
        return cell;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.weekCollectView]) {
        return CGSizeMake(WEEKWIDTH, 25);

    }
    else {
        return CGSizeMake(WEEKWIDTH, 45);
    }
}

//定义每个UICollectionView 的 margin


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsZero;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.dateCollectView]) {
        NSDate *tempDate = self.dateDataList[indexPath.row];
        [self updateSelectedDate:tempDate];
    }
    
}

//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat contentOffsetX = self.dateCollectView.contentOffset.x;
    if (scrollView == self.dateCollectView) {
        // 无限下拉
        // 快到底部的时候把头上的数据清除掉，再往后面添加内容
        if (contentOffsetX > self.contentWidth - ScreenWidth)
        {
            [self addNextBatchData];
        }
        // 无限上拉
        // 快到顶部的时候把尾部的数据清楚掉，再往头上添加内容
        else if (contentOffsetX < 0)
        {
            [self addLastBatchData];
        }
    }

}



#pragma mark - request Delegate

#pragma mark - Interface
- (void)dateCellClick:(HMWeeklySelectedDateBlock)block {
    self.block = block;
}

- (void)configDate:(NSDate *)date {
       if ([date isEarlierThanOrEqualTo:self.dateDataList.lastObject] && [date isLaterThanOrEqualTo:self.dateDataList.firstObject]) {
        
        self.selectedDate = date;
        [self performSelector:@selector(scrollSomeDay:) withObject:date afterDelay:0.00001];
        
        [self.dateCollectView reloadData];
    }
    
}
#pragma mark - init UI

- (UICollectionView *)weekCollectView {
    if (!_weekCollectView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _weekCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _weekCollectView.dataSource = self;
        _weekCollectView.delegate = self;
        [_weekCollectView setBackgroundColor:[UIColor clearColor]];
        
        [_weekCollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[UICollectionViewCell at_identifier]];

        
    }
    return _weekCollectView;
}

- (UICollectionView *)dateCollectView {
    if (!_dateCollectView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _dateCollectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _dateCollectView.dataSource = self;
        _dateCollectView.delegate = self;
        [_dateCollectView setPagingEnabled:YES];
        [_dateCollectView setBackgroundColor:[UIColor clearColor]];
        
        [_dateCollectView registerClass:[HMDateSelectCollectionViewCell class] forCellWithReuseIdentifier:[HMDateSelectCollectionViewCell at_identifier]];
        
        
    }
    return _dateCollectView;
}

- (NSMutableArray <NSDate *> *)dateDataList {
    if (!_dateDataList) {
        _dateDataList = [NSMutableArray array];
        if (self.selectedDate) {
            [_dateDataList addObject:self.selectedDate];
            NSInteger week = [self.selectedDate weekday];
            // 插入开始日期前的数组
            for (int i = 1; i <= OFFSETDAYS + week - 1; i++) {
               [_dateDataList insertObject:[self.selectedDate dateBySubtractingDays:i] atIndex:0];
            }
            // 插入开始日期后的数组
            for (int i = 1; i <= OFFSETDAYS +  7 - week; i++) {
                [_dateDataList addObject:[self.selectedDate dateByAddingDays:i]];
            }
            
            self.contentWidth = self.dateDataList.count * WEEKWIDTH;
        }
    }
    return _dateDataList;
}

- (UIButton *)backTodayBtn {
    if (!_backTodayBtn) {
        _backTodayBtn = [[UIButton alloc]init];
        [_backTodayBtn setImage:[UIImage imageNamed:@"im_jt"] forState:UIControlStateNormal];
        [_backTodayBtn setTitle:@"回今天" forState:UIControlStateNormal];
        [_backTodayBtn addTarget:self action:@selector(backTodayClick) forControlEvents:UIControlEventTouchUpInside];
        [_backTodayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [_backTodayBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_backTodayBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"ffffff"]];
        [_backTodayBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    return _backTodayBtn;
}
@end

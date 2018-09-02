 //
//  HMStepHistoryTopView.m
//  HMClient
//
//  Created by jasonwang on 2017/8/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMStepHistoryTopView.h"
#import "HMStepHistoryCollectionViewCell.h"
#import "HMStepHistoryModel.h"

#define CELLWIDTH   ( ScreenWidth / PAGESIZE )
#define PAGESIZE    5
@interface HMStepHistoryTopView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UILabel *stepCountLb;
@property (nonatomic, strong) UILabel *distanceLb;
@property (nonatomic, strong) UILabel *calorieLb;
@property (nonatomic) NSInteger selectCellIndex;
@property (nonatomic, copy) AddNextPageBlock block;
@property (nonatomic, copy) selectedModelBlock selectedBlock;
@property (nonatomic, copy) isScrollingBlock scrollBlock;

@end

@implementation HMStepHistoryTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self configElements];

    }
    return self;
}
#pragma mark -private method
- (void)configElements {
    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PK_im_back2"]];
    [backView setUserInteractionEnabled:YES];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.equalTo(@(220 * (ScreenWidth / 375)));
    }];
    
    [backView addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(backView);
        make.bottom.equalTo(backView).offset(-10);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Triangle 2"]];
    
    [backView addSubview:arrow];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.bottom.equalTo(backView);
    }];
    
    [self addSubview:self.dateLb];
    [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(backView.mas_bottom).offset(15);
    }];
    
    [self addSubview:self.distanceLb];
    [self.distanceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_bottom).offset(-70);
    }];
    
    [self addSubview:self.stepCountLb];
    [self.stepCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceLb);
        make.width.equalTo(self.distanceLb);
        make.left.equalTo(self);
        make.right.equalTo(self.distanceLb.mas_left);
    }];
    
    [self addSubview:self.calorieLb];
    [self.calorieLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.distanceLb);
        make.width.equalTo(self.distanceLb);
        make.right.equalTo(self);
        make.left.equalTo(self.distanceLb.mas_right);
    }];
    
    UILabel *stepCountUnitLb = [UILabel new];
    [stepCountUnitLb setText:@"步数"];
    [stepCountUnitLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    [stepCountUnitLb setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *distanceUnitLb = [UILabel new];
    [distanceUnitLb setText:@"里程(km)"];
    [distanceUnitLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    [distanceUnitLb setFont:[UIFont systemFontOfSize:14]];
    
    UILabel *calorieLbUnitLb = [UILabel new];
    [calorieLbUnitLb setText:@"卡路里(千卡)"];
    [calorieLbUnitLb setTextColor:[UIColor colorWithHexString:@"999999"]];
    [calorieLbUnitLb setFont:[UIFont systemFontOfSize:14]];
    
    [self addSubview:stepCountUnitLb];
    [self addSubview:distanceUnitLb];
    [self addSubview:calorieLbUnitLb];
    
    [stepCountUnitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.stepCountLb);
        make.top.equalTo(self.stepCountLb.mas_bottom).offset(10);
    }];
    
    [distanceUnitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.distanceLb);
        make.centerY.equalTo(stepCountUnitLb);
    }];
    
    [calorieLbUnitLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.calorieLb);
        make.centerY.equalTo(stepCountUnitLb);
    }];
    
}

- (void)updatePositionWithScrollView:(UIScrollView *)scrollView {
    CGFloat offsetX = MAX(0, scrollView.contentOffset.x);
    
    [self.collectionView setContentOffset:CGPointMake(CELLWIDTH * round((offsetX / CELLWIDTH)), 0) animated:YES];
    [self configSelectedCellIndex:round((offsetX / CELLWIDTH)) + (PAGESIZE / 2)];
}

- (void)configSelectedCellIndex:(NSInteger)index {

    self.selectCellIndex = index;
    
    HMStepHistoryModel *selectedModel = self.dataList[self.selectCellIndex];
    [self.collectionView reloadData];
    [self configStepViewWithModel:selectedModel];
    
}

- (void)configStepViewWithModel:(HMStepHistoryModel *)selectedModel {
    NSString *dateString = @"";

    switch (self.selectedType) {
        case HMGroupPKScreening_Day:
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:selectedModel.upTimeStamp / 1000];
            if ([date isToday]) {
                dateString = @"今日";
            }
            else {
                dateString = [date formattedDateWithFormat:@"MM.dd"];
            }
            break;
        }
        case HMGroupPKScreening_Week:
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:selectedModel.upTimeStamp / 1000];
            NSDate *sunday = [date dateByAddingDays:6];
            
            if ([[NSDate date] isEarlierThanOrEqualTo:sunday]&&[[NSDate date] isLaterThanOrEqualTo:date]) {
                dateString = @"本周";
            }
            else {
                dateString = [NSString stringWithFormat:@"%@-%@",[date formattedDateWithFormat:@"MM.dd"],[sunday formattedDateWithFormat:@"MM.dd"]];
            }
            
            break;
        }
        case HMGroupPKScreening_Month:
        {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:selectedModel.upTimeStamp / 1000];
            if (date.month == [NSDate date].month) {
                dateString = @"本月";
            }
            else {
                dateString = [date formattedDateWithFormat:@"MM月"];
            }
            break;
        }

    }
    
    
    [self.dateLb setText:[NSString stringWithFormat:@"%@，步行记录",dateString]];

    [self.stepCountLb setText:[NSString stringWithFormat:@"%ld",(long)selectedModel.stepCount]];
    
    CGFloat distance = selectedModel.stepCount * 0.0006;
    [self.distanceLb setText:[NSString stringWithFormat:@"%.2f",distance]];
    CGFloat time = distance / 3.0;
    [self.calorieLb setText:[NSString stringWithFormat:@"%.f",60 * 3.1 * time]];
    if (self.selectedBlock) {
        self.selectedBlock(selectedModel);
    }
}

- (void)XConnectionScrollToBottom {
    if (self.dataList && self.dataList.count) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataList.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
}

#pragma mark - event Response

#pragma mark - Delegate

//定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


//每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMStepHistoryCollectionViewCell at_identifier] forIndexPath:indexPath];
    if ([self.dataList[indexPath.row] isKindOfClass:[HMStepHistoryModel class]]) {
        [cell fillDataWithModel:self.dataList[indexPath.row] groupPKScreening:self.selectedType];
        [cell updateCellStatusIsSelect:(self.selectCellIndex == indexPath.row)];
    }
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELLWIDTH, self.frame.size.height - 150);
}

//定义每个UICollectionView 的 margin

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        if (indexPath.row > self.dataList.count - 1 - (PAGESIZE / 2) || indexPath.row < (PAGESIZE / 2)) {
            return;
        }
        
        [self.collectionView setContentOffset:CGPointMake(CELLWIDTH * (indexPath.row - PAGESIZE / 2), 0) animated:YES];
        [self configSelectedCellIndex:indexPath.row];
    }
}


//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePositionWithScrollView:scrollView];

    if (self.scrollBlock) {
        self.scrollBlock(NO);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView.contentOffset.x < 0) {
        // 加载下一页数据
        if (self.block) {
            self.block();
        }
        
    }
    
    if (decelerate) {
        if (self.scrollBlock) {
            self.scrollBlock(YES);
        }
        return;
    }
    [self updatePositionWithScrollView:scrollView];
}
#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)addDataWithArray:(NSArray<HMStepHistoryModel *> *)array requstSize:(NSInteger)requstSize{
    NSArray *temp = [[array reverseObjectEnumerator] allObjects];

    if (self.page < 2) {
        // 第一页
        [self.dataList removeAllObjects];
        
        [self.dataList addObjectsFromArray:temp];
        NSMutableArray *lastArr = [NSMutableArray array];
        for (int i = 0; i < PAGESIZE / 2 ; i++) {
            [lastArr addObject:[HMStepHistoryModel new]];
        }
        [self.dataList addObjectsFromArray:lastArr];
        if (temp.count < requstSize) {
            
            [lastArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.dataList insertObject:obj atIndex:0];
                
            }];
            
        }
        NSInteger lastItemIndex = self.dataList.count-1-(PAGESIZE / 2);
        HMStepHistoryModel *tempModel = self.dataList[lastItemIndex];
        self.selectCellIndex = lastItemIndex;
        [self configStepViewWithModel:tempModel];
    }
    else {
        NSMutableArray *tempMub = [NSMutableArray array];
        [tempMub addObjectsFromArray:temp];
        [tempMub addObjectsFromArray:self.dataList];
        self.dataList = tempMub;
    }
    [self.collectionView reloadData];
    
    if (self.page < 2) {
        // 第一页滚到最右边
        [self performSelector:@selector(XConnectionScrollToBottom) withObject:nil afterDelay:0.00001];
    }
    else {
        // 分页加载滚到原地
        if (temp && temp.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:temp.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            [self configSelectedCellIndex:temp.count + (PAGESIZE / 2)];

        }
    }


}

- (void)addEmptyData {
    HMStepHistoryModel *temp = self.dataList.firstObject;
    if (!temp.upTimeStamp) {
        return;
    }
    NSMutableArray *lastArr = [NSMutableArray array];
    for (int i = 0; i < PAGESIZE / 2 ; i++) {
        [lastArr addObject:[HMStepHistoryModel new]];
    }
    NSMutableArray *tempMub = [NSMutableArray array];
    [tempMub addObjectsFromArray:lastArr];
    [tempMub addObjectsFromArray:self.dataList];
    self.dataList = tempMub;
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self configSelectedCellIndex:0 + (PAGESIZE / 2)];
}

- (void)addNextPageAction:(AddNextPageBlock)block {
    self.block = block;
}

- (void)configTable:(selectedModelBlock)block {
    self.selectedBlock = block;
}

- (void)scrollCallBack:(isScrollingBlock)block {
    self.scrollBlock = block;
}
#pragma mark - init UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [_collectionView registerClass:[HMStepHistoryCollectionViewCell class] forCellWithReuseIdentifier:[HMStepHistoryCollectionViewCell at_identifier]];
        
        
    }
    return _collectionView;
}
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UILabel *)dateLb {
    if (!_dateLb ) {
        _dateLb = [UILabel new];
        [_dateLb setFont:[UIFont systemFontOfSize:14]];
        [_dateLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [_dateLb setText:@"步行记录"];
    }
    return _dateLb;
}

- (UILabel *)stepCountLb {
    if (!_stepCountLb ) {
        _stepCountLb = [UILabel new];
        [_stepCountLb setFont:[UIFont systemFontOfSize:27]];
        [_stepCountLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_stepCountLb setTextAlignment:NSTextAlignmentCenter];

    }
    return _stepCountLb;
}

- (UILabel *)distanceLb {
    if (!_distanceLb ) {
        _distanceLb = [UILabel new];
        [_distanceLb setFont:[UIFont systemFontOfSize:27]];
        [_distanceLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_distanceLb setTextAlignment:NSTextAlignmentCenter];

    }
    return _distanceLb;
}

- (UILabel *)calorieLb {
    if (!_calorieLb ) {
        _calorieLb = [UILabel new];
        [_calorieLb setFont:[UIFont systemFontOfSize:27]];
        [_calorieLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_calorieLb setTextAlignment:NSTextAlignmentCenter];
    }
    return _calorieLb;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

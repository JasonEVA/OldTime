//
//  HMWeightHistoryTopView.m
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMWeightHistoryTopView.h"
#import "HMWeightHistoryCollectionViewCell.h"
#import "HMSuperviseDetailModel.h"

#define CELLWIDTH   ( ScreenWidth / PAGESIZE )
#define PAGESIZE    7
@interface HMWeightHistoryTopView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic) CGFloat minTarget;
@property (nonatomic) CGFloat maxTarget;
@property (nonatomic, copy) AddNextPageBlock block;
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation HMWeightHistoryTopView
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
        make.bottom.left.right.equalTo(backView);
        make.top.equalTo(backView).offset(35);
    }];
    
    [backView addSubview:self.dateLb];
    [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(15);
        make.top.equalTo(backView).offset(10);
    }];

}

- (void)XConnectionScrollToBottom {
    if (self.dataList && self.dataList.count) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.dataList.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
}

- (void)configDateLbWith:(long long)time {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time / 1000];
    [self.dateLb setText:[date formattedDateWithFormat:@"MM月dd日"]];
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
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMWeightHistoryCollectionViewCell at_identifier] forIndexPath:indexPath];
    [cell fillDataWithModel:self.dataList[indexPath.row] maxTarget:self.maxTarget minTarget:self.minTarget isSelected:self.selectedIndex == indexPath.row];
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELLWIDTH, (220 * (ScreenWidth / 375)) - 35);
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
    self.selectedIndex = indexPath.row;
    [self.collectionView reloadData];
    HMSuperviseDetailModel *model = self.dataList[indexPath.row];
    [self configDateLbWith:model.startday];
}


//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMSuperviseDetailModel *model = self.dataList[indexPath.row];

    if (!model.startday) {
        return NO;
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView.contentOffset.x < 0) {
        // 加载下一页数据
        if (self.block) {
            self.block();
        }
        
    }
    
}

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)addDataWithDataList:(NSArray *)dataList maxTarget:(CGFloat)maxTarget minTarget:(CGFloat)minTarget {
    NSArray *temp = [[dataList reverseObjectEnumerator] allObjects];
    
    if (self.page < 2) {
        // 第一页
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:temp];
        NSMutableArray *lastArr = [NSMutableArray array];
        for (int i = 0; i < PAGESIZE / 2 ; i++) {
            [lastArr addObject:[HMSuperviseDetailModel new]];
        }
        [self.dataList addObjectsFromArray:lastArr];
        
        if (temp.count < (PAGESIZE / 2)) {
            
            for (int i = 0; i < ((PAGESIZE / 2) - temp.count + 1); i++) {
                [self.dataList insertObject:[HMSuperviseDetailModel new] atIndex:0];
            }

        }

        self.selectedIndex = self.dataList.count - 1 - (PAGESIZE / 2);
        HMSuperviseDetailModel *model = self.dataList[self.selectedIndex];
        [self configDateLbWith:model.startday];

    }
    else {
        NSMutableArray *tempMub = [NSMutableArray array];
        [tempMub addObjectsFromArray:temp];
        [tempMub addObjectsFromArray:self.dataList];
        self.dataList = tempMub;
    }
    
    self.minTarget = 0;
    
    CGFloat unit = (maxTarget - self.minTarget) / 11;
    NSString *tempString = [NSString stringWithFormat:@"%f",unit];
    NSInteger tempInt = ((tempString.integerValue / 10) + 1) * 10;
    
    NSMutableArray *YdataList = [NSMutableArray array];
    for (int i = 0; i < 11; i++) {
        [YdataList addObject:[NSString stringWithFormat:@"%.f",self.minTarget + tempInt * i]];
    }
    self.maxTarget = self.minTarget + tempInt * (11);
    
    [self.collectionView reloadData];
    
    if (self.page < 2) {
        // 第一页滚到最右边
        [self performSelector:@selector(XConnectionScrollToBottom) withObject:nil afterDelay:0.00001];
    }
    else {
        // 分页加载滚到原地
        if (temp && temp.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:temp.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        }
    }
    
}

- (void)addNextPageAction:(AddNextPageBlock)block {
    self.block = block;
}

#pragma mark - init UI
- (UILabel *)dateLb {
    if (!_dateLb ) {
        _dateLb = [UILabel new];
        [_dateLb setFont:[UIFont systemFontOfSize:14]];
        [_dateLb setTextColor:[UIColor colorWithHexString:@"ffffff"]];
    }
    return _dateLb;
}

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
        
        [_collectionView registerClass:[HMWeightHistoryCollectionViewCell class] forCellWithReuseIdentifier:[HMWeightHistoryCollectionViewCell at_identifier]];
        
        
    }
    return _collectionView;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

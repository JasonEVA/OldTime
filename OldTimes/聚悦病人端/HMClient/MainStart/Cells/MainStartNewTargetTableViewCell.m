//
//  MainStartNewTargetTableViewCell.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "MainStartNewTargetTableViewCell.h"
#import "MainStartHealthTargetModel.h"
#import "DashboardCollectionViewCell.h"

#define kDashboardSize CGSizeMake(105, 125)


@interface MainStartNewTargetTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)  NSMutableArray  *arrayViews; // <##>
@property (nonatomic, strong)  UICollectionView  *collectionView; // <##>
@property (nonatomic, copy)  NSArray<MainStartHealthTargetModel *>  *dataSource; // <##>
@property (nonatomic, assign)  CGFloat  lineSpace; // <##>
@property (nonatomic, copy)  TargetValueClickedCompletion  clickCompletion; // <##>
@end

@implementation MainStartNewTargetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor commonCuttingLineColor];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}
#pragma mark - Interface Method
- (void)configTargetItems:(NSArray<MainStartHealthTargetModel *> *)targetItems {
    self.dataSource = targetItems;
    if (targetItems.count <= 3) {
        self.lineSpace = ([UIScreen mainScreen].bounds.size.width - kDashboardSize.width * targetItems.count) / (CGFloat)(targetItems.count + 1);
    }
    else {
        self.lineSpace = 10;
    }

    [self.collectionView reloadData];
}

- (void)addTargetValueClickedCompletion:(TargetValueClickedCompletion)completion {
    self.clickCompletion = completion;
}

#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (!self.clickCompletion || self.dataSource.count == 0) {
        return;
    }
    MainStartHealthTargetModel *model = self.dataSource[indexPath.row];
    self.clickCompletion(model);
}

#pragma mark - CollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DashboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DashboardCollectionViewCell class]) forIndexPath:indexPath];
    self.dataSource.count == 0 ?: [cell configTargetData:self.dataSource[indexPath.row]];
    return cell;
}


#pragma mark - CollectionFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kDashboardSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, self.lineSpace, 0, self.lineSpace);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpace;
}

#pragma mark - Init
- (NSMutableArray *)arrayViews {
    if (!_arrayViews) {
        _arrayViews = [NSMutableArray array];
    }
    return _arrayViews;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[DashboardCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DashboardCollectionViewCell class])];
    }
    return _collectionView;
}


@end

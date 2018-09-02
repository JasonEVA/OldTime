//
//  TrainEffectOnEachPartView.m
//  Shape
//
//  Created by jasonwang on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainEffectOnEachPartView.h"
#import "UILabel+EX.h"
#import "MyDefine.h"
#import <Masonry.h>
#import "TrainArrowLabelCell.h"

@interface TrainEffectOnEachPartView()
@property (nonatomic, copy) NSArray *dataList;
@property (nonatomic, copy) NSArray *strenthList;

@end

@implementation TrainEffectOnEachPartView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self initComponent];
        [self updateConstraints];
        //self.dataList = [NSArray arrayWithObjects:@"小腿",@"背",@"大腿",@"肩膀",@"上臂",@"胸",@"腹肌",@"脂肪", nil];
    }
    return self;
}

#pragma mark -private method
- (void)initComponent
{
    [self addSubview:self.backView];
    [self.backView addSubview:self.collectView];
}

- (void)setMyData:(TrainGetTrainInfoModel *)model
{
    self.dataList = [model.trainingDescription allKeys];
    self.strenthList = [model.trainingDescription allValues];
    [self.collectView reloadData];
}
#pragma mark - event Response

#pragma mark - uicollectionview delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"UICollectionViewCell";
    TrainArrowLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    [cell setTitel:self.dataList[indexPath.row] strenth:[self.strenthList[indexPath.row] intValue]];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(55, self.frame.size.height/2);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}

#pragma mark - request Delegate

#pragma mark - updateViewConstraints
- (void)updateConstraints
{
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.collectView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    [super updateConstraints];
}

#pragma mark - init UI

- (UIImageView *)backView
{
    if (!_backView) {
        _backView = [[UIImageView alloc]init];
        [_backView setImage:[UIImage imageNamed:@"train_downback"]];
    }
    return _backView;
}

- (UICollectionView *)collectView
{
    if (!_collectView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectView setDelegate:self];
        [_collectView setDataSource:self];
        [_collectView setBackgroundColor:[UIColor clearColor]];
        [_collectView registerClass:[TrainArrowLabelCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectView;
}

@end

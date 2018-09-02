//
//  MissionPickerBar.m
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionPickerBar.h"
#import "MissionNavCollectionViewCell.h"
#import "TaskWhiteBoardModel.h"
#import "UIColor+Hex.h"
#import <Masonry/Masonry.h>
#import "MyDefine.h"

@interface MissionPickerBar()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UICollectionView  *collectView;

@property(nonatomic, strong) NSArray  *titleArray;
/**
 *  被选中的序号
 */
@property(nonatomic, assign) NSInteger  selectedIndex;

@end
@implementation MissionPickerBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self addSubview:self.titleLabel];
        [self addSubview:self.collectView];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.top.bottom.equalTo(self);
        }];
        
        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.top.right.bottom.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - collectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MissionNavCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MissionNavCollectionViewCell identifier] forIndexPath:indexPath];
    cell.titleLbl.text = self.titleArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 30, 0, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr  = self.titleArray[indexPath.row];
    CGSize titleSize = [titleStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
    return CGSizeMake(titleSize.width, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger newIndex[] = {0,0};
    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
    MissionNavCollectionViewCell *preCell = (MissionNavCollectionViewCell *)[collectionView cellForItemAtIndexPath:newPath];
    MissionNavCollectionViewCell *nowCell = (MissionNavCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectedIndex = indexPath.row;
    preCell.selected = NO;
    nowCell.selected = YES;
    
    if (indexPath.row == [self.titleArray count] - 1) {
        if ([self.delegate respondsToSelector:@selector(MissionPickerBarDelegateCallBack_optionsSelected)]) {
            [self.delegate MissionPickerBarDelegateCallBack_optionsSelected];
        }
    }
    
    else {
        if ([self.delegate respondsToSelector:@selector(MissionPickerBarDelegateCallBack_setEventStateNameWithIndex:)]) {
            [self.delegate MissionPickerBarDelegateCallBack_setEventStateNameWithIndex:indexPath.row];
        }
    }
}

#pragma mark - Getter and Setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor mtc_colorWithHex:0x959595];
        _titleLabel.text = [LOCAL(MISSION_ENDTIME) stringByAppendingString:@":"];
        _titleLabel.backgroundColor = [UIColor mtc_colorWithHex:0xf1f1f1];
    }
    return _titleLabel;
}

- (UICollectionView *)collectView
{
    if (!_collectView)
    {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowlayout];
        _collectView.backgroundColor = [UIColor mtc_colorWithHex:0xf1f1f1];
        
        _collectView.delegate = self;
        _collectView.dataSource = self;
        
        [_collectView registerClass:[MissionNavCollectionViewCell class] forCellWithReuseIdentifier:[MissionNavCollectionViewCell identifier]];
    }
    return _collectView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[LOCAL(MISSION_TODAY),LOCAL(MISSION_TOMORROW),LOCAL(MISSION_THEDAYAFTERTOMORROW),LOCAL(MISSION_WEEKLATER),LOCAL(MISSION_MONTHLATER),LOCAL(MISSION_CHOOSE)];
    }
    return _titleArray;
}


@end

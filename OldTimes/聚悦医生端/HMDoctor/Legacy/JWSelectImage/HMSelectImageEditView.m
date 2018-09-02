//
//  HMSelectImageEditView.m
//  HMDoctor
//
//  Created by jasonwang on 2017/6/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMSelectImageEditView.h"
#import "HMSelectImageCollectionViewCell.h"

@interface HMSelectImageEditView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) UIImage *addImage;
@property (nonatomic, strong) UILabel *reminLb;

@end

@implementation HMSelectImageEditView

- (instancetype)initWithMaxSelectedCount:(NSInteger)maxCount {
    if (self = [super init]) {
        self.maxCount = maxCount;
        self.dataList = [NSMutableArray arrayWithObject:self.addImage];
        self.selectedImageArr = [NSMutableArray array];
        self.reminLb = [UILabel new];
        [self.reminLb setText:[NSString stringWithFormat:@"添加照片，最多%ld张",(long)self.maxCount]];
        [self.reminLb setTextColor:[UIColor colorWithHexString:@"999999"]];
        [self.reminLb setFont:[UIFont systemFontOfSize:15]];
        
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-5);
        }];
        
        [self.collectionView addSubview:self.reminLb];
        [self.reminLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.collectionView);
            make.left.equalTo(self.collectionView).offset(75);
        }];
    }
    return self;
}
#pragma mark -- UICollectionViewDataSource

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
    UIImage *tempImage = self.dataList[indexPath.row];
    HMSelectImageCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMSelectImageCollectionViewCell at_identifier] forIndexPath:indexPath];
    
    [cell fillDataWithImage:tempImage showDeleteBtn:![tempImage isEqual:self.addImage]];
    __weak typeof(self) weakSelf = self;
    [cell deleteImageClick:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.dataList removeObject:tempImage];
        [strongSelf.selectedImageArr removeObject:tempImage];
        
        if (strongSelf.selectedImageArr.count < strongSelf.maxCount && ![strongSelf.dataList containsObject:strongSelf.addImage]) {
            [strongSelf.dataList addObject:strongSelf.addImage];
        }
        [strongSelf.reminLb setHidden:strongSelf.selectedImageArr.count];
        [strongSelf.collectionView reloadData];
    }];
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 65);
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
    UIImage *tempImage = self.dataList[indexPath.row];
    if ([tempImage isEqual:self.addImage]) {
        // 添加图片
        if (self.delegate && [self.delegate respondsToSelector:@selector(HMSelectImageEditViewDelegateCallBack_addImage)]) {
            [self.delegate HMSelectImageEditViewDelegateCallBack_addImage];
        }
    }
    else {
        // 查看大图
        if (self.delegate && [self.delegate respondsToSelector:@selector(HMSelectImageEditViewDelegateCallBack_showBigImageWithIndex:)]) {
            [self.delegate HMSelectImageEditViewDelegateCallBack_showBigImageWithIndex:indexPath];
        }
        
    }
}

//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)updateDataListWithArray:(NSArray *)imageArr {
    [self.selectedImageArr addObjectsFromArray:imageArr];
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:self.selectedImageArr];

    if (self.selectedImageArr.count < self.maxCount) {
        [self.dataList addObject:self.addImage];
    }
    [self.reminLb setHidden:self.selectedImageArr.count];
    [self.collectionView reloadData];
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
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
        [_collectionView registerClass:[HMSelectImageCollectionViewCell class] forCellWithReuseIdentifier:[HMSelectImageCollectionViewCell at_identifier]];
    }
    return _collectionView;
}

- (UIImage *)addImage {
    if (!_addImage) {
        _addImage = [UIImage imageNamed:@"im_add"];
    }
    return _addImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

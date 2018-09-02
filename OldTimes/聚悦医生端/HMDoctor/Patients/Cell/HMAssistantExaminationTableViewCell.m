//
//  HMAssistantExaminationTableViewCell.m
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMAssistantExaminationTableViewCell.h"
#import "MWPhotoBrowser.h"

@interface HMAssistantExaminationTableViewCell () //<UICollectionViewDataSource,UICollectionViewDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *ivBackground;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomlineView;
@property (nonatomic, strong) UIView *circleView;

@property (nonatomic, strong) UILabel *orgNameLabel;
@property (nonatomic, strong) UILabel *indicesNameLabel;
//@property (nonatomic, strong) UIView *horizontalLineView;

//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSMutableArray *bigImgArray;
//@property (nonatomic, strong) NSMutableArray *samllImgArray;
//@property (nonatomic, strong) NSArray *showPhotos;

@property (nonatomic, strong) UIImageView *rightIconView;
@end

@implementation HMAssistantExaminationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.ivBackground];
        [self.contentView addSubview:self.topLineView];
        [self.contentView addSubview:self.bottomlineView];
        [self.contentView addSubview:self.circleView];
        [self.contentView addSubview:self.orgNameLabel];
        [self.contentView addSubview:self.indicesNameLabel];
//        [self.contentView addSubview:self.horizontalLineView];
//        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.rightIconView];
        
        [self configElements];
    }
    return self;
}

- (void)configElements{
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@8.5);
        make.width.mas_equalTo(@1);
        make.top.equalTo(self.contentView);
        make.left.equalTo(self).with.offset(51);
    }];
    
    [_circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@12);
        make.width.mas_equalTo(@12);
        make.top.equalTo(_topLineView.mas_bottom).with.offset(1.5);
        make.centerX.equalTo(_topLineView);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(2);
        //make.height.mas_equalTo(@13);
        make.centerY.equalTo(_circleView);
        make.right.equalTo(_circleView.mas_left).with.offset(-4);
    }];
    
    [_bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@1);
        make.top.equalTo(_circleView.mas_bottom).with.offset(1.5);
        make.left.equalTo(_topLineView.mas_left);
        make.bottom.equalTo(self.contentView);
    }];
    
    [_ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_circleView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-12);
        make.top.equalTo(self);
        make.bottom.equalTo(self).with.offset(-5);
    }];
    
    [_indicesNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ivBackground).offset(20);
        make.top.equalTo(_ivBackground).offset(10);
    }];
    
    [_orgNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_indicesNameLabel.mas_left);
        make.bottom.equalTo(_ivBackground.mas_bottom).offset(-10);
    }];
    
    [_rightIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.right.equalTo(_ivBackground).with.offset(-9);
        make.top.equalTo(_indicesNameLabel);
    }];
    
//    [_horizontalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_ivBackground).offset(10);
//        make.right.equalTo(_ivBackground.mas_right);
//        make.top.equalTo(_indicesNameLabel.mas_bottom).offset(10);
//        make.height.mas_equalTo(@1);
//    }];
    
//    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_indicesNameLabel).offset(-5);
//        make.right.equalTo(_orgNameLabel);
//        make.top.equalTo(_horizontalLineView.mas_bottom).offset(5);
//        make.height.mas_equalTo(@70);
//    }];
}

- (void)setCheckImgList:(HMGetCheckImgListModel *)model{
    
    if (!model) {
        return;
    }
    
//    [self.bigImgArray removeAllObjects];
//    [self.samllImgArray removeAllObjects];
    NSDate* dateMonth = [NSDate dateWithString:model.checkTime formatString:@"yyyy-MM-dd"];
    NSString* monthStr = [dateMonth formattedDateWithFormat:@"yyyy/MM/dd"];
    [_dateLabel setText:monthStr];
    //[_dateLabel setText:model.checkTime];
    [_indicesNameLabel setText:model.indicesName];
    [_orgNameLabel setText:model.orgName];
//    __weak typeof(self) weakSelf = self;
//    [model.imgList enumerateObjectsUsingBlock:^(HMImgListModel * _Nonnull imgList, NSUInteger idx, BOOL * _Nonnull stop) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        if (!kStringIsEmpty(imgList.bigImg)) {
//            [strongSelf.bigImgArray addObject:imgList.bigImg];
//        }
//        
//        if (!kStringIsEmpty(imgList.samllImg)) {
//            [strongSelf.samllImgArray addObject:imgList.samllImg];
//        }
//    }];
//    
//    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.samllImgArray.count;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    [cell setBackgroundColor:[UIColor orangeColor]];
//    
//    UIImageView *imageView = [cell viewWithTag:990];
//    
//    if ( imageView == nil ) {
//        imageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_default"]];
//        [cell.contentView addSubview:imageView];
//        imageView.tag = 990;
//        cell.clipsToBounds = YES;
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(cell.contentView);
//        }];
//    }
//    imageView.contentMode = UIViewContentModeScaleToFill;
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.samllImgArray objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"img_default"]];
//    
//    return cell;
//}
//
//- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSMutableArray *photos = [NSMutableArray array];
//    
//    for (int i=0; i<self.bigImgArray.count; i++) {
//        
//        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:self.bigImgArray[i]]]];
//    }
//
//    self.showPhotos = photos;
//    
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    [browser setCurrentPhotoIndex:indexPath.row];
//    [self.ownerViewController.navigationController pushViewController:browser animated:YES];
//}
//
//#pragma mark -MWPhotoBrowser
//
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
//    return self.showPhotos.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
//    
//    if (index < self.showPhotos.count) {
//        return [self.showPhotos objectAtIndex:index];
//    }
//    return nil;
//}
//
//
//#pragma mark - CHTCollectionViewDelegateWaterfallLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    float imgWidth = (ScreenWidth-_ivBackground.left-40)/4;
//    return CGSizeMake(imgWidth-10, imgWidth-10);
//}
//
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
//
//- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 2.0f;
//}
//
//- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 2.0f;
//}

#pragma mark -- UI init
- (UIImageView *)ivBackground{
    if (!_ivBackground) {
        _ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"history_record_bg"]];
    }
    return _ivBackground;
}

- (UIView *)circleView{
    if (!_circleView) {
        _circleView = [[UIView alloc]init];
        [_circleView setBackgroundColor:[UIColor mainThemeColor]];
        _circleView.layer.cornerRadius = 6;
        _circleView.layer.masksToBounds = YES;
    }
    return _circleView;
}

- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [UIView new];
        [_topLineView setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _topLineView;
}

- (UIView *)bottomlineView{
    if (!_bottomlineView) {
        _bottomlineView = [UIView new];
        [_bottomlineView setBackgroundColor:[UIColor mainThemeColor]];
    }
    return _bottomlineView;
}

- (UILabel *)orgNameLabel{
    if (!_orgNameLabel) {
        _orgNameLabel = [[UILabel alloc] init];
        [_orgNameLabel setFont:[UIFont font_26]];
        [_orgNameLabel setTextColor:[UIColor commonGrayTextColor]];
        [_orgNameLabel setText:@"西南医院体检中心"];
    }
    return _orgNameLabel;
}

- (UILabel *)indicesNameLabel{
    if (!_indicesNameLabel) {
        _indicesNameLabel = [[UILabel alloc] init];
        [_indicesNameLabel setFont:[UIFont font_28]];
        [_indicesNameLabel setTextColor:[UIColor commonBlackTextColor_333333]];
        [_indicesNameLabel setText:@"血常规"];
    }
    return _indicesNameLabel;
}

//- (UIView *)horizontalLineView{
//    if (!_horizontalLineView) {
//        _horizontalLineView = [UIView new];
//        [_horizontalLineView setBackgroundColor:[UIColor commonCuttingLineColor]];
//    }
//    return _horizontalLineView;
//}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        [_dateLabel setFont:[UIFont font_26]];
        [_dateLabel setTextColor:[UIColor commonGrayTextColor]];
        [_dateLabel setText:@"03/09"];
        [_dateLabel setNumberOfLines:0];
    }
    return _dateLabel;
}

- (UIImageView *)rightIconView{
    if (!_rightIconView) {
        _rightIconView = [UIImageView new];
        [_rightIconView setImage:[UIImage imageNamed:@"right"]];
    }
    return _rightIconView;
}

//- (UICollectionView *)collectionView{
//    if (!_collectionView) {
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
//        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
//        self.collectionView.dataSource = self;
//        self.collectionView.delegate = self;
//        [_collectionView setBackgroundColor:[UIColor whiteColor]];
//    }
//    return _collectionView;
//}

//- (NSMutableArray *)bigImgArray{
//    if (!_bigImgArray) {
//        _bigImgArray = [NSMutableArray array];
//    }
//    return _bigImgArray;
//}
//
//- (NSMutableArray *)samllImgArray{
//    if (!_samllImgArray) {
//        _samllImgArray = [NSMutableArray array];
//    }
//    return _samllImgArray;
//}

@end

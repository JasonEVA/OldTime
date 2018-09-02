//
//  HMSEPersonSpaceCollectionTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.

#import "HMSEPersonSpaceCollectionTableViewCell.h"
#import "HMSEPersonSpaceTopCollectionViewCell.h"

@interface HMSEPersonSpaceCollectionTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HMSEPersonSpaceCollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@100);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -private method
- (void)configElements {
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMSEPersonSpaceTopCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMSEPersonSpaceTopCollectionViewCell at_identifier] forIndexPath:indexPath];
    NSString *imageTitel = @"";
    NSString *titelName = @"";
    switch (indexPath.row) {
        case SEPersonSpaceCollectionType_MyOrder:
        {
            imageTitel = @"me_ic_dd";
            titelName = @"我的订单";
            break;
        }
        case SEPersonSpaceCollectionType_MyService:
        {
            imageTitel = @"me_ic_fw";
            titelName = @"我的服务";
            break;
        }
        case SEPersonSpaceCollectionType_MyAppointment:
        {
            imageTitel = @"me_ic_yz";
            titelName = @"我的约诊";
            break;
        }
        case SEPersonSpaceCollectionType_MyIntegal:
        {
            imageTitel = @"me_ic_jf";
            titelName = @"我的积分";
            break;
        }
        default:
            break;
    }
    [cell.iconImageView setImage:[UIImage imageNamed:imageTitel]];
    [cell.titelLb setText:titelName];
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((ScreenWidth / 4), 100);
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
    if ([self.personSpaceDelegate respondsToSelector:@selector(HMSEPersonSpaceCollectionTableViewCellDelegateCallBack_CollectType:)]) {
        [self.personSpaceDelegate HMSEPersonSpaceCollectionTableViewCellDelegateCallBack_CollectType:indexPath.row];
    }
}

//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        [_collectionView registerClass:[HMSEPersonSpaceTopCollectionViewCell class] forCellWithReuseIdentifier:[HMSEPersonSpaceTopCollectionViewCell at_identifier]];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
    }
    return _collectionView;
}
@end

//
//  HMSEMainStartWithCollectionTableViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEMainStartWithCollectionTableViewCell.h"
#import "HMSEMainStartTodayMissionCollectionViewCell.h"
#import "PlanMessionListItem.h"
#import "HMSEMainStartHealthClassCollectionViewCell.h"
#import "HealthEducationItem.h"
#import "HMSEMainStartToolBoxCollectionViewCell.h"

@interface HMSEMainStartWithCollectionTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titelLb;

@property (nonatomic) SEMainStartType type;

@property (nonatomic, strong) NSArray<PlanMessionListItem *> *todayMissionDataList;

@property (nonatomic, strong) NSArray<HealthEducationItem *> *healthClassDataList;
@end
@implementation HMSEMainStartWithCollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];

        [self.contentView addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
//        [self.contentView addSubview:self.arrowView];
//        [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.iconView);
//            make.right.equalTo(self.contentView).offset(-15);
//        }];
        
        [self.contentView addSubview:self.moreLb];
        [self.moreLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconView);
            make.right.equalTo(self.contentView).offset(-15);
        }];
        
        [self.contentView addSubview:self.titelLb];
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.centerY.equalTo(self.iconView);
            make.right.lessThanOrEqualTo(self.moreLb.mas_left).offset(-10);
        }];

        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(40);
            make.right.equalTo(self.contentView);
            make.height.equalTo(@110);
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
    switch (self.type) {
        case SEMainStartType_TodayMission:
            return self.todayMissionDataList.count;
            break;
        case SEMainStartType_HealthClass:
            return self.healthClassDataList.count;
            break;
            case SEMainStartType_ToolBox:
            return 3;
            break;
        default:
            return 3;
            break;
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
    id cell;
    switch (self.type) {
        case SEMainStartType_TodayMission:
        {
             cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMSEMainStartTodayMissionCollectionViewCell at_identifier] forIndexPath:indexPath];
            [cell fillDataWithModel:self.todayMissionDataList[indexPath.row]];
            break;
        }
        case SEMainStartType_HealthClass:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMSEMainStartHealthClassCollectionViewCell at_identifier] forIndexPath:indexPath];
            [cell fillDataWithModel:self.healthClassDataList[indexPath.row]];
            break;
        }
        case SEMainStartType_ToolBox:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMSEMainStartToolBoxCollectionViewCell at_identifier] forIndexPath:indexPath];
            NSString *imageTitel = @"";
            NSString *titelName = @"";
            switch (indexPath.row) {
                case SEMainStartToolBoxType_Experts:
                {// 约专家
                    imageTitel = @"SEMainStartic_yuezhuanjia";
                    titelName = @"约专家";
                    [[cell unOpenImage] setHidden:YES];
                    break;
                }
                case SEMainStartToolBoxType_Nutrition:
                {// 营养库
                    imageTitel = @"SEMainStartic_yinyangku";
                    titelName = @"营养库";
                    [[cell unOpenImage] setHidden:YES];

                    break;
                }
                case SEMainStartToolBoxType_Pharmacy:
                {// 药品库
                    imageTitel = @"SEMainStartic_yaopinku";
                    titelName = @"药品库";
                    [[cell unOpenImage] setHidden:NO];
                    break;
                }
                default:
                    break;
            }
            [[cell iconImageView] setImage:[UIImage imageNamed:imageTitel]];
            [[cell titelLb] setText:titelName];
            
            break;
        }
        default:
            break;
    }
    
    
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.type) {
        case SEMainStartType_TodayMission:
            return CGSizeMake(162, 97);
            break;
        case SEMainStartType_HealthClass:
            return CGSizeMake(230, 133);
            break;
        case SEMainStartType_ToolBox:
            return CGSizeMake((ScreenWidth / 3), 95);
            break;
        default:
            return CGSizeMake(80, 100);
            break;
    }
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
    if ([self.JWdelegate respondsToSelector:@selector(HMSEMainStartWithCollectionTableViewCellDelegateCallBack_didSelectCollectionCellWithIndexPath:tableViewCellType:)]) {
        [self.JWdelegate HMSEMainStartWithCollectionTableViewCellDelegateCallBack_didSelectCollectionCellWithIndexPath:indexPath tableViewCellType:self.type];
    }
    
}

//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithTodayMissionTypeDataList:(NSArray *)dataList {
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    [self.iconView setImage:[UIImage imageNamed:@"SEMainStartic_renwu"]];
    [self.titelLb setText:@"今日任务"];
    self.todayMissionDataList = dataList;
    self.type = SEMainStartType_TodayMission;
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(40);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@97);
    }];

    [self.collectionView reloadData];
    
    __block NSUInteger tempInt = 0;
    [self.todayMissionDataList enumerateObjectsUsingBlock:^(PlanMessionListItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.status isEqualToString:@"3"]) {
            tempInt = idx;
            *stop = YES;
        }
    }];
    if (!self.todayMissionDataList.count) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:tempInt inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    if (tempInt > 0) {
        CGPoint point = self.collectionView.contentOffset;
        [self.collectionView setContentOffset:CGPointMake(point.x - 50, point.y) animated:NO];
    }
}

- (void)fillDataWithHealthClassTypeDataList:(NSArray *)dataList {
    [self.iconView setImage:[UIImage imageNamed:@"SEMainStartic_ketang"]];
    [self.titelLb setText:@"健康课堂"];
    self.healthClassDataList = [HealthEducationItem mj_objectArrayWithKeyValuesArray:dataList];
    self.type = SEMainStartType_HealthClass;
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(40);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@133);
    }];
    
    [self.collectionView reloadData];
}

- (void)fillDataWithToolBoxType {
    [self.iconView setImage:[UIImage imageNamed:@"SEMainStartic_gongju"]];
    [self.titelLb setText:@"工具箱"];
    self.type = SEMainStartType_ToolBox;
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(40);
        make.right.equalTo(self.contentView);
        make.height.equalTo(@95);
    }];
    
    [self.collectionView reloadData];
}

#pragma mark - DZNEmptyDataSetDelegate

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"赞，任务全部完成！" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]}];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"SEMainStartim_zan"];
}



- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    if (!self.todayMissionDataList ||self.todayMissionDataList.count == 0) {
        return YES;
    }
    return NO;
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
        [_collectionView setBackgroundColor:[UIColor whiteColor]];

        [_collectionView registerClass:[HMSEMainStartTodayMissionCollectionViewCell class] forCellWithReuseIdentifier:[HMSEMainStartTodayMissionCollectionViewCell at_identifier]];
        [_collectionView registerClass:[HMSEMainStartHealthClassCollectionViewCell class] forCellWithReuseIdentifier:[HMSEMainStartHealthClassCollectionViewCell at_identifier]];
        [_collectionView registerClass:[HMSEMainStartToolBoxCollectionViewCell class] forCellWithReuseIdentifier:[HMSEMainStartToolBoxCollectionViewCell at_identifier]];
        
    }
    return _collectionView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartic_zhuanjia"]];
    }
    return _iconView;
}
//- (UIImageView *)arrowView {
//    if (!_arrowView) {
//        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_r_gray_arrow"]];
//    }
//    return _arrowView;
//}

- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_titelLb setFont:[UIFont systemFontOfSize:15]];
    }
    return _titelLb;
}

- (UILabel *)moreLb {
    if (!_moreLb) {
        _moreLb = [UILabel new];
        [_moreLb setText:@"查看全部 >"];
        [_moreLb setTextColor:[UIColor commonGrayTextColor]];
        [_moreLb setFont:[UIFont systemFontOfSize:13]];
    }
    return _moreLb;
}

@end

//
//  HMSEMainStartDashboardTableViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/4.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMSEMainStartDashboardTableViewCell.h"
#import "HMSEMainStartDashboardCollectionViewCell.h"
#import "MainStartHealthTargetModel.h"
#import "NewbieGuideInteractor.h"
#import "SEMainStartTodayStepsView.h"

#define kDashboardSize CGSizeMake(115, 120)

@interface HMSEMainStartDashboardTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *recordHealthBtn;
@property (nonatomic, assign)  CGFloat  lineSpace; // <##>
@property (nonatomic, copy)  NSArray<MainStartHealthTargetModel *>  *dataSource; // <##>
@property (nonatomic, copy)  HMSEMainStartDashboardClickedCompletion  clickCompletion; // <##>

@property (nonatomic, strong) SEMainStartTodayStepsView *todayStepsView;

@end

@implementation HMSEMainStartDashboardTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.todayStepsView];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.recordHealthBtn];
        
        [self.todayStepsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(@40);
        }];
        
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.todayStepsView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@140);
        }];
        
        [self.recordHealthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.collectionView.mas_bottom);
            make.width.equalTo(@157);
            make.height.equalTo(@40);
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
- (void) detectbuttonClicked:(id) sender
{
    // 新手指引
    if (![NewbieGuideInteractor showedNewbieGuideWithType:NewbieGuidePageTypeAddBloodPressure]) {
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        [NewbieGuideInteractor presentNewbieGuideWithGuideType:NewbieGuidePageTypeAddBloodPressure presentingViewController:rootViewController animated:NO];
        return;
    }
    
    [[ActionStatutManager shareInstance] addActionStatusWithPageName:@"首页－记录健康"];
    [HMViewControllerManager createViewControllerWithControllerName:@"BodyDetectStartViewController"ControllerObject:nil];
}
#pragma mark - Delegate

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
    HMSEMainStartDashboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HMSEMainStartDashboardCollectionViewCell class]) forIndexPath:indexPath];
    self.dataSource.count == 0 ?: [cell configTargetData:self.dataSource[indexPath.row]];
    return cell;
}


#pragma mark - CollectionFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return kDashboardSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, self.lineSpace, 0, self.lineSpace);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpace;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpace;
}
#pragma mark - request Delegate

#pragma mark - Interface
- (void)configTargetItems:(NSArray<MainStartHealthTargetModel *> *)targetItems {
    self.dataSource = targetItems;
    if (targetItems.count <= 3) {
        self.lineSpace = ([UIScreen mainScreen].bounds.size.width - kDashboardSize.width * targetItems.count) / (CGFloat)(targetItems.count + 1);
    }
    else {
        self.lineSpace = 10;
    }
    self.lineSpace = MAX(0, self.lineSpace);
    
    [self.collectionView reloadData];
    
    //同步手环数据
    [self.todayStepsView syncBraceletData];
}

- (void)addTargetValueClickedCompletion:(HMSEMainStartDashboardClickedCompletion)completion{
    self.clickCompletion = completion;
}
#pragma mark - init UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[HMSEMainStartDashboardCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([HMSEMainStartDashboardCollectionViewCell class])];
    }
    return _collectionView;
}

- (UIButton *)recordHealthBtn {
    if (!_recordHealthBtn) {
        _recordHealthBtn = [[UIButton alloc] init];
        [_recordHealthBtn setTitle:@"记录健康" forState:UIControlStateNormal];
        [_recordHealthBtn setTitleColor:[UIColor colorWithHexString:@"31c9ba"] forState:UIControlStateNormal];
        [_recordHealthBtn.layer setCornerRadius:20];
        [_recordHealthBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_recordHealthBtn.layer setBorderColor:[[UIColor colorWithHexString:@"31c9ba"] CGColor]];
        [_recordHealthBtn.layer setBorderWidth:1];
        [_recordHealthBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_recordHealthBtn addTarget:self action:@selector(detectbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordHealthBtn;
}

- (SEMainStartTodayStepsView *)todayStepsView{
    if (!_todayStepsView) {
        _todayStepsView = [[SEMainStartTodayStepsView alloc] init];
        [_todayStepsView setBackgroundColor:[UIColor whiteColor]];
    }
    return _todayStepsView;
}
@end

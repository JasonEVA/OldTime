//
//  SEMainStaffTeamTableViewCell.m
//  HMClient
//
//  Created by JasonWang on 2017/5/2.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SEMainStaffTeamTableViewCell.h"
//#import "SDCycleScrollView.h"
#import "HMStaffInfoCollectionViewCell.h"
#import "TeamInfo.h"
#import "StaffDetail.h"
#import "UserCareInfo.h"
#import "HMWeatherModel.h"

@interface SEMainStaffTeamTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

//@property (nonatomic, strong) SDCycleScrollView *scrollTitelView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TeamDetail *teamModel;
@property (nonatomic, strong) UIImageView *weatherImageView;
@property (nonatomic, strong) UILabel *weatherLabel;

@end

@implementation SEMainStaffTeamTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SEMainStartic_zhuanjia"]];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        UILabel *titelLb = [UILabel new];
        [titelLb setText:@"我的专家团"];
        [titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
        [titelLb setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:titelLb];
        
        [titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(iconView);
            make.left.equalTo(iconView.mas_right).offset(10);
        }];
        
//        [self.contentView addSubview:self.scrollTitelView];
//        
//        [self.scrollTitelView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(iconView);
//            make.left.equalTo(titelLb.mas_right);
//            make.right.equalTo(self.contentView).offset(-5);
//            make.height.equalTo(@40);
//        }];
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
- (NSArray *)configDataList:(NSArray *)array {
    if (!array || !array.count) {
        return @[];
    }
    
    NSMutableArray <StaffInfo *>*tempArr = [NSMutableArray arrayWithArray:array];
   __block StaffInfo *leaderModel = nil;
    NSInteger leaderStaffId = self.teamModel.teamStaffId;
    [tempArr enumerateObjectsUsingBlock:^(StaffInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.staffId == leaderStaffId) {
            leaderModel = obj;
            [tempArr removeObject:obj];
        }
    }];
    if (leaderModel) {
        [tempArr insertObject:leaderModel atIndex:0];
    }
    return tempArr;
}

- (NSArray *)configConCareList:(NSArray <UserCareInfo *>*)modelArr {
    __block NSMutableArray *tempArr = [NSMutableArray array];
    [modelArr enumerateObjectsUsingBlock:^(UserCareInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArr addObject:obj.careCon];
    }];
    return tempArr;
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.teamModel.orgTeamDet.count;
}

//定义展示的Section的个数

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StaffInfo *staffModel = [self configDataList:self.teamModel.orgTeamDet][indexPath.row];
    
    HMStaffInfoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[HMStaffInfoCollectionViewCell at_identifier] forIndexPath:indexPath];
    [cell setStaffInfo:staffModel];
    [cell setIsTeamLeader:(self.teamModel.teamStaffId == staffModel.staffId)];
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(80, 100);
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
    StaffInfo *staffModel = [self configDataList:self.teamModel.orgTeamDet][indexPath.row];
    //跳转到医生详情
    [HMViewControllerManager createViewControllerWithControllerName:@"StaffDetailViewController" ControllerObject:staffModel];
}

//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - request Delegate

#pragma mark - Interface

- (void)fillDataWithTeamModel:(TeamDetail *)model cares:(NSArray<UserCareInfo *> *)caresArr{
    self.teamModel = model;
    [self.collectionView reloadData];
//    if (caresArr.count) {
//        self.scrollTitelView.titlesGroup = [[self configConCareList:caresArr] copy];
//    }
}

- (void)fillWeatherDataWithModel:(HMWeatherModel *)model {
    if (!model  || ![model isKindOfClass:[HMWeatherModel class]] || !model.city.length) {
        return;
    }
    
    [self.weatherImageView setImage:[UIImage imageNamed:[self acquireWeatherImageNameWith:model.weather]]];
    [self.weatherLabel setText:[NSString stringWithFormat:@"%@ %@℃ %@",model.weather,model.temperature,model.city]];
    if (![self.contentView.subviews containsObject:self.weatherLabel]) {
        [self.contentView addSubview:self.weatherLabel];
        [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-12);
            make.centerY.equalTo(self.contentView.mas_top).offset(20);
        }];
    }
    if (![self.contentView.subviews containsObject:self.weatherImageView]) {
        [self.contentView addSubview:self.weatherImageView];
        [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.weatherLabel);
            make.right.equalTo(self.weatherLabel.mas_left);
        }];
    }
   
}

- (NSString *)acquireWeatherImageNameWith:(NSString *)weatherName {
    NSString *weather = @"";
    if ([weatherName containsString:@"-"]) {
        NSRange range = [weatherName rangeOfString:@"-"];
        weather = [weatherName substringToIndex:range.location];
    }
    else {
        weather = weatherName;
    }
    NSString *imageName = @"";
    if ([weather isEqualToString:@"晴"]) {
        imageName = @"ic-qin";
    }
    else if ([weather isEqualToString:@"多云"]) {
        imageName = @"ic_duoyun";

    }
    else if ([weather isEqualToString:@"阴"]) {
        imageName = @"ic_yin";
        
    }
    else if ([weather isEqualToString:@"阵雨"]) {
        imageName = @"ic_zhenyu";
        
    }
    else if ([weather isEqualToString:@"雷阵雨"]) {
        imageName = @"ic_leizhenyu";
        
    }
    else if ([weather isEqualToString:@"雷阵雨并伴有冰雹"]) {
        imageName = @"ic_leizhenyu";
        
    }
    else if ([weather isEqualToString:@"雨夹雪"]) {
        imageName = @"ic_yujiaxue";
        
    }
    else if ([weather isEqualToString:@"小雨"]) {
        imageName = @"ic_xiaoyu";
        
    }
    else if ([weather isEqualToString:@"中雨"]) {
        imageName = @"ic_zhongyu";
        
    }
    else if ([weather isEqualToString:@"大雨"]) {
        imageName = @"ic_dayu";
        
    }
    else if ([weather isEqualToString:@"暴雨"]) {
        imageName = @"ic_baoyu";
        
    }
    else if ([weather isEqualToString:@"大暴雨"]) {
        imageName = @"ic_dabaoyu";
        
    }
    else if ([weather isEqualToString:@"特大暴雨"]) {
        imageName = @"ic_tedabaoyu";
        
    }
    else if ([weather isEqualToString:@"阵雪"]) {
        imageName = @"ic_zhenxue";
        
    }
    else if ([weather isEqualToString:@"小雪"]) {
        imageName = @"iuc_xiaoxue";
        
    }
    else if ([weather isEqualToString:@"中雪"]) {
        imageName = @"ic_zhongxue";
        
    }
    else if ([weather isEqualToString:@"大雪"]) {
        imageName = @"ic_daxue";
        
    }
    else if ([weather isEqualToString:@"暴雪"]) {
        imageName = @"ic_baoxue";
        
    }
    else if ([weather isEqualToString:@"雾"]) {
        imageName = @"ic_wu";
        
    }
    else if ([weather isEqualToString:@"冻雨"]) {
        imageName = @"ic_dongyu";
        
    }
    else if ([weather isEqualToString:@"霾"]) {
        imageName = @"ic_mai";
        
    }
    else if ([weather isEqualToString:@"浮尘"]) {
        imageName = @"ic_fuchen";
        
    }
    else if ([weather isEqualToString:@"扬沙"]) {
        imageName = @"ic_yangsha";
        
    }
    else if ([weather isEqualToString:@"强沙尘暴"]) {
        imageName = @"ic_qiangshachenbao";
        
    }
        return imageName;
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
        [_collectionView registerClass:[HMStaffInfoCollectionViewCell class] forCellWithReuseIdentifier:[HMStaffInfoCollectionViewCell at_identifier]];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        
    }
    return _collectionView;
}

- (UILabel *)weatherLabel {
    if (!_weatherLabel) {
        _weatherLabel = [UILabel new];
        [_weatherLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
        [_weatherLabel setFont:[UIFont systemFontOfSize:13]];
    }
    return _weatherLabel;
}

- (UIImageView *)weatherImageView {
    if (!_weatherImageView) {
        _weatherImageView = [[UIImageView alloc] init];
    }
    return _weatherImageView;
}

//- (SDCycleScrollView *)scrollTitelView {
//    if (!_scrollTitelView) {
//        
//        _scrollTitelView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth - 50, 40) delegate:self placeholderImage:nil];
//        _scrollTitelView.scrollDirection = UICollectionViewScrollDirectionVertical;
//        _scrollTitelView.onlyDisplayText = YES;
//        _scrollTitelView.autoScrollTimeInterval = 3.0;
//        [_scrollTitelView setTitleLabelBackgroundColor:[UIColor whiteColor]];
//        [_scrollTitelView setTitleLabelTextFont:[UIFont systemFontOfSize:15]];
//        [_scrollTitelView setTitleLabelTextColor:[UIColor colorWithHexString:@"666666"]];
//        [_scrollTitelView setBackgroundColor:[UIColor whiteColor]];
//    }
//    return _scrollTitelView;
//}

@end

//
//  ServiceTeamMemberInfoView.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "ServiceTeamMemberInfoView.h"
#import "DoctorAvatarInfoCollectionViewCell.h"

@interface ServiceTeamMemberInfoView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)  UICollectionView  *collectionView; // <##>
@property (nonatomic)  CGSize  itemSize; // <##>
@property (nonatomic, strong)  UICollectionViewFlowLayout  *layout; // <##>
@property (nonatomic, copy)  NSArray<StaffInfo *>  *dataSource; // <##>
@property (nonatomic, copy)  MemberClickedCompletion  memberClickedCompletion; // <##>
@property (nonatomic)  NSInteger  leaderID; // <##>
@end

@implementation ServiceTeamMemberInfoView

#pragma mark - Interface Method
- (instancetype)initWithFlowLayout:(nullable UICollectionViewFlowLayout *)layout itemSize:(CGSize)itemSize;
{
    self = [super init];
    if (self) {
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[[UIColor colorWithHexString:@"3cd395"] CGColor], (__bridge id)[[UIColor colorWithHexString:@"31c9ba"] CGColor]];
        gradientLayer.locations = @[@0.5, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 1.0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, ScreenWidth, 90.0);
        [self.layer addSublayer:gradientLayer];

        self.itemSize = itemSize;
        self.layout = layout ? layout : [self defaultLayout];
        [self configElements];
    }
    return self;
}

- (void)configDoctorsInfo:(NSArray<StaffInfo *> *)doctors leaderID:(NSInteger)leaderID memberClickedCompletion:(MemberClickedCompletion)memberClickedCompletion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.staffId == %ld",leaderID];
    NSArray *leaderArray = [doctors filteredArrayUsingPredicate:predicate];
    NSMutableArray *sortedDoctors = [doctors mutableCopy];
    if (leaderArray.count) {
        [sortedDoctors removeObject:leaderArray.firstObject];
        [sortedDoctors insertObject:leaderArray.firstObject atIndex:0];
    }
    self.dataSource = sortedDoctors;
    self.leaderID = leaderID;
    self.memberClickedCompletion = memberClickedCompletion;
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {
    
    [self addSubview:self.collectionView];
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

// 设置数据
- (void)configData {
    
}

// 默认布局
- (UICollectionViewFlowLayout *)defaultLayout {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 25;
    layout.itemSize = self.itemSize;
    layout.sectionInset = UIEdgeInsetsMake(5, 20, 10, 20);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return layout;
}
#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DoctorAvatarInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DoctorAvatarInfoCollectionViewCell at_identifier] forIndexPath:indexPath];
    if (self.dataSource.count < indexPath.row + 1) {
        return cell;
    }
    StaffInfo* staff = self.dataSource[indexPath.row];
    [cell configNativeImageName:staff.imgUrl name:staff.staffName teamLeader:(staff.staffId == self.leaderID)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count < indexPath.row + 1) {
        return;
    }
    StaffInfo* staff = self.dataSource[indexPath.row];
    if (self.memberClickedCompletion && staff) {
        self.memberClickedCompletion(staff);
    }
    if ([self.delegate respondsToSelector:@selector(serviceTeamMemberInfoViewDelegateCallBack_memberClickedWithData:indexPath:)]) {
        [self.delegate serviceTeamMemberInfoViewDelegateCallBack_memberClickedWithData:staff indexPath:indexPath];
    }
}
#pragma mark - Init

- (UICollectionView *)collectionView {
    if (!_collectionView) {

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        [_collectionView registerClass:[DoctorAvatarInfoCollectionViewCell class] forCellWithReuseIdentifier:[DoctorAvatarInfoCollectionViewCell at_identifier]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

@end

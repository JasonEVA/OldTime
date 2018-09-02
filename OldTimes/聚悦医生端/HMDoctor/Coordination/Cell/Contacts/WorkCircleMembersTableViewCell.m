//
//  WorkCircleMembersTableViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "WorkCircleMembersTableViewCell.h"
#import "DoctorAvatarInfoCollectionViewCell.h"

CGFloat const itemWidth = 70;
CGFloat const itemHeight = 123;

@interface WorkCircleMembersTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)  UICollectionView  *collectionView; // <##>
@property (nonatomic, copy)  NSArray  *memberList; // <##>
@end

@implementation WorkCircleMembersTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configElements];
    }
    return self;
}

- (void)configCellData:(NSArray *)memberList {
    self.memberList = memberList;
    [self.collectionView reloadData];
}

#pragma mark - Private Method
// 设置元素控件
- (void)configElements {

    [self.contentView addSubview:self.collectionView];
    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

// 设置数据
- (void)configData {
    
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.memberList.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DoctorAvatarInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DoctorAvatarInfoCollectionViewCell class]) forIndexPath:indexPath];
    if (indexPath.row == self.memberList.count) {
        // 新增成员+
        [cell configNativeImage:[UIImage imageNamed:@"c_workCircle_add"] name:@"" position:@""];
    }
    else {
        // 人员信息
        [cell configCellData:self.memberList[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.memberList.count) {
        if ([self.delegate respondsToSelector:@selector(workCircleMembersTableViewCellDelegateCallBack_addMemberClicked)]) {
            [self.delegate workCircleMembersTableViewCellDelegateCallBack_addMemberClicked];
        }
    }
    else {
        if ([self.delegate respondsToSelector:@selector(workCircleMembersTableViewCellDelegateCallBack_memberClickedWithData:indexPath:)]) {
            [self.delegate workCircleMembersTableViewCellDelegateCallBack_memberClickedWithData:self.memberList[indexPath.row] indexPath:indexPath];
        }
    }
    
}
#pragma mark - Init

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 3;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.sectionInset = UIEdgeInsetsMake(15, 13, 15, 13);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[DoctorAvatarInfoCollectionViewCell class] forCellWithReuseIdentifier:[DoctorAvatarInfoCollectionViewCell at_identifier]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

@end

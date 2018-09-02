//
//  GroupInfoHeaderTableViewCell.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GroupInfoHeaderTableViewCell.h"
#import "DoctorAvatarInfoCollectionViewCell.h"
#import "UserProfileModel+ProfileExtension.h"
#import "StaffServiceInfoModel.h"
@interface GroupInfoHeaderTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)  UILabel  *createTimeTitle; // <##>
@property (nonatomic, strong)  UILabel  *createTimeValue; // <##>
@property (nonatomic, strong)  UILabel  *servicePatientsTitle; // <##>
@property (nonatomic, strong)  UILabel  *servicePatientsValue; // <##>
@property (nonatomic, strong)  UILabel  *currentPatientsTitle; // <##>
@property (nonatomic, strong)  UILabel  *currentPatientsValue; // <##>
@property (nonatomic, strong)  UICollectionView  *collectionView; // <##>
@property (nonatomic, strong) UserProfileModel *model;
@property (nonatomic, strong) StaffServiceInfoModel  *seviceModel;

@end
@implementation GroupInfoHeaderTableViewCell

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


// 设置元素控件
- (void)configElements {
    [self.contentView addSubview:self.createTimeTitle]; // <##>
    [self.contentView addSubview:self.createTimeValue]; // <##>
    [self.contentView addSubview:self.servicePatientsTitle]; // <##>
    [self.contentView addSubview:self.servicePatientsValue]; // <##>
    [self.contentView addSubview:self.currentPatientsTitle]; // <##>
    [self.contentView addSubview:self.currentPatientsValue]; // <##>
    [self.contentView addSubview:self.collectionView];
    // 设置数据
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.servicePatientsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView.mas_centerX);
    }];
    [self.servicePatientsValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(5);
        make.centerY.equalTo(self.servicePatientsTitle);
    }];
    [self.createTimeValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.servicePatientsTitle.mas_left).offset(-10);
        make.centerY.equalTo(self.servicePatientsTitle);
    }];
    [self.createTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.createTimeValue.mas_left).offset(-5);
        make.centerY.equalTo(self.servicePatientsTitle);
    }];
    [self.currentPatientsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.servicePatientsValue.mas_right).offset(10);
        make.centerY.equalTo(self.servicePatientsTitle);
    }];
    [self.currentPatientsValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPatientsTitle.mas_right).offset(5);
        make.centerY.equalTo(self.servicePatientsTitle);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.servicePatientsTitle.mas_bottom).offset(15);
        make.left.right.bottom.equalTo(self.contentView);
    }];

}

// 设置数据
- (void)configDataWith:(UserProfileModel *)model {
    self.model = model;
    [self.collectionView reloadData];
}

#pragma mark - Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.memberList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DoctorAvatarInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DoctorAvatarInfoCollectionViewCell class]) forIndexPath:indexPath];
    UserProfileModel *model = self.model.memberList[indexPath.row];
    [cell configCellData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(groupInfoHeaderTableViewCellDelegateCallBack_doctorClickedWithIndex:)]) {
        [self.delegate groupInfoHeaderTableViewCellDelegateCallBack_doctorClickedWithIndex:indexPath.row];
    }
}
#pragma mark - Init

- (void)setSeviceModel:(StaffServiceInfoModel *)seviceModel
{
    _seviceModel = seviceModel;
    self.createTimeValue.text = seviceModel.createTime?:@"";
    self.servicePatientsValue.text = [NSString stringWithFormat:@"%@位用户",seviceModel.allNum?:@"0"];
    self.currentPatientsValue.text = [NSString stringWithFormat:@"%@位",seviceModel.serviceNum?:@"0"];
}

- (UILabel *)createTimeTitle {
    if (!_createTimeTitle) {
        _createTimeTitle = [UILabel new];
        [_createTimeTitle setText:@"已组建"];
        [_createTimeTitle setFont:[UIFont font_28]];
        [_createTimeTitle setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _createTimeTitle;
}

- (UILabel *)createTimeValue {
    if (!_createTimeValue) {
        _createTimeValue = [UILabel new];
        [_createTimeValue setText:@"2年3个月"];
        [_createTimeValue setFont:[UIFont font_28]];
        [_createTimeValue setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    return _createTimeValue;
}
- (UILabel *)servicePatientsTitle {
    if (!_servicePatientsTitle) {
        _servicePatientsTitle = [UILabel new];
        [_servicePatientsTitle setText:@"服务过"];
        [_servicePatientsTitle setFont:[UIFont font_28]];
        [_servicePatientsTitle setTextColor:[UIColor commonLightGrayColor_999999]];
    }
    return _servicePatientsTitle;
}
- (UILabel *)servicePatientsValue {
    if (!_servicePatientsValue) {
        _servicePatientsValue = [UILabel new];
        [_servicePatientsValue setText:@"79位用户"];
        [_servicePatientsValue setFont:[UIFont font_28]];
        [_servicePatientsValue setTextColor:[UIColor commonBlackTextColor_333333]];

    }
    return _servicePatientsValue;
}
- (UILabel *)currentPatientsTitle {
    if (!_currentPatientsTitle) {
        _currentPatientsTitle = [UILabel new];
        [_currentPatientsTitle setText:@"当前服务"];
        [_currentPatientsTitle setFont:[UIFont font_28]];
        [_currentPatientsTitle setTextColor:[UIColor commonLightGrayColor_999999]];

    }
    return _currentPatientsTitle;
}
- (UILabel *)currentPatientsValue {
    if (!_currentPatientsValue) {
        _currentPatientsValue = [UILabel new];
        [_currentPatientsValue setText:@"3位"];
        [_currentPatientsValue setFont:[UIFont font_28]];
        [_currentPatientsValue setTextColor:[UIColor commonBlackTextColor_333333]];
    }
    return _currentPatientsValue;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 20;
        layout.itemSize = CGSizeMake(65, 123);
        layout.sectionInset = UIEdgeInsetsMake(0, 25, 0, 25);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView registerClass:[DoctorAvatarInfoCollectionViewCell class] forCellWithReuseIdentifier:[DoctorAvatarInfoCollectionViewCell at_identifier]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

@end

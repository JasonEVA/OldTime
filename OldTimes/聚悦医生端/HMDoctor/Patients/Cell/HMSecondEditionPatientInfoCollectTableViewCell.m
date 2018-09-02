//
//  HMSecondEditionPatientInfoCollectTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionPatientInfoCollectTableViewCell.h"
#import "HMSecondEditionFreePatientInfoCheckModel.h"
#import "HMSecondEditionFreeCheckGroupModel.h"
#define scale  (ScreenWidth / (750.0 / 2))

@interface HMSecondEditionPatientInfoCollectTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titelLb;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, copy) NSArray<HMSecondEditionFreePatientInfoCheckModel *> *dataList;
@end

@implementation HMSecondEditionPatientInfoCollectTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self.contentView addSubview:self.titelLb];
        [self.contentView addSubview:self.collectView];
        
        [self.titelLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15 * scale);
            make.right.lessThanOrEqualTo(self.contentView).offset(-15);
            make.height.equalTo(@20);
        }];
        
        [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titelLb.mas_bottom).offset(10);
            make.bottom.right.equalTo(self.contentView).offset(-15);
            make.left.equalTo(self.contentView).offset(15);
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

#pragma mark - UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UICollectionViewCell at_identifier] forIndexPath:indexPath];
    cell.backgroundColor = [UIColor purpleColor];
    NSURL *url = [NSURL URLWithString:[self.dataList[indexPath.row] imgUrl]];
    UIImageView *imageView = [UIImageView new];
     // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
    // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageColor:[UIColor colorWithHexString:@"999999"] size:CGSizeMake(1, 1) cornerRadius:0]];
    [cell.contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(HMSecondEditionPatientInfoCollectTableViewCellDelegateCallBack_imageClick:groupName:)]) {
        [self.delegate HMSecondEditionPatientInfoCollectTableViewCellDelegateCallBack_imageClick:indexPath groupName:self.titelLb.text];
    }
}

#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithModel:(HMSecondEditionFreeCheckGroupModel *)model {
    [self.titelLb setText:model.groupName];
    self.dataList = model.groupData;
    [self.collectView reloadData];
}
#pragma mark - init UI
- (UILabel *)titelLb {
    if (!_titelLb) {
        _titelLb = [UILabel new];
        [_titelLb setFont:[UIFont font_32]];
        [_titelLb setTextColor:[UIColor colorWithHexString:@"333333"]];
    }
    return _titelLb;
}
- (UICollectionView *)collectView {
    if (!_collectView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(60, 60);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
        
        _collectView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.delegate = self;
        _collectView.dataSource = self;
        
        [_collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[UICollectionViewCell at_identifier]];
    }
    return _collectView;
}

@end

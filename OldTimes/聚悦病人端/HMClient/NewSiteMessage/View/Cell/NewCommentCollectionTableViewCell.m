//
//  NewCommentCollectionTableViewCell.m
//  HMClient
//
//  Created by jasonwang on 2017/3/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NewCommentCollectionTableViewCell.h"
#import "JWLeftCollectionViewFlowLayout.h"
#import "NewCommentSelectLabelModel.h"

@interface NewCommentCollectionTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray <NewCommentSelectLabelModel *>*dataList;
@end


@implementation NewCommentCollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(24);
            make.left.equalTo(self.contentView).offset(12.5);
            make.right.equalTo(self.contentView).offset(-12.5);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@130);
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
    NewCommentSelectLabelModel *model = self.dataList[indexPath.row];
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UICollectionViewCell at_identifier] forIndexPath:indexPath];
    
    [cell.layer setCornerRadius:15];
    [cell.layer setBorderColor:[[UIColor colorWithHexString:@"dddddd"] CGColor]];
    [cell.layer setBorderWidth:0.5];
    
    UILabel *label = [[UILabel alloc] init];
    if (model.isSelected) {
        label.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor mainThemeColor];
    }
    else {
        label.textColor = [UIColor colorWithHexString:@"666666"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    

    label.font = [UIFont systemFontOfSize:12];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.text = model.tag;
    
    for (id subView in cell.contentView.subviews) {
        
        [subView removeFromSuperview];
        
    }
    
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    
    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewCommentSelectLabelModel *model = self.dataList[indexPath.row];

    NSString *string = model.tag;
    UIFont *font = [UIFont systemFontOfSize:12];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return CGSizeMake(size.width + 20, 30);
}

//定义每个UICollectionView 的 margin

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 2.5, 5, 2.5);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewCommentSelectLabelModel *model = self.dataList[indexPath.row];

    model.isSelected ^= 1;
    
    [self.collectionView reloadData];
}

//返回这个UICollectionView是否可以被选择

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark - request Delegate

#pragma mark - Interface
- (void)fillDataWithArray:(NSArray <NewCommentSelectLabelModel *>*)array {
    self.dataList = array;
    [self.collectionView reloadData];
}
#pragma mark - init UI
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JWLeftCollectionViewFlowLayout *flowLayout=[[JWLeftCollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _collectionView.dataSource = self;
        
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[UICollectionViewCell at_identifier]];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];

    }
    return _collectionView;
}

@end

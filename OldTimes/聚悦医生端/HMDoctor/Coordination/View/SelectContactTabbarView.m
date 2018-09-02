//
//  SelectContactTabbarView.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SelectContactTabbarView.h"
#import "SelectContactCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "KVONSMutableArrayModel.h"
#import "ContactInfoModel.h"
#import "PatientInfo.h"


#define ROWHEIGHT    36
@interface SelectContactTabbarView ()<UICollectionViewDelegate,UICollectionViewDataSource>
//@property (nonatomic, strong) UIImageView *searchImageView;
//@property (nonatomic, strong) UITextField *searchTextfield;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)  UIView  *bottomLine; // <##>
@property (nonatomic, copy)  ContactTabbarDeleteContactHandler  deleteHandler; // <##>
@property (nonatomic, strong) MASConstraint *collectionViewWidth;
@property (nonatomic, strong) NSMutableDictionary *dictSelectInter;

@end

@implementation SelectContactTabbarView

- (instancetype)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self configElements];
    }
    return self;
}

- (void)addTabbarViewDeleteContactNoti:(ContactTabbarDeleteContactHandler)deleteHandler {
    self.deleteHandler = deleteHandler;
}

- (void)configData:(NSArray *)dataSource {
    self.arraySelect = [dataSource mutableCopy];
    [self.collectionView reloadData];
    [self UIRefresh];
}

#pragma mark -private method
- (void)configElements {
    
    [self addSubview:self.collectionView];
//    [self addSubview:self.searchImageView];
//    [self addSubview:self.searchTextfield];
    [self addSubview:self.bottomLine];
    [self myLayout];
}

- (void)myLayout
{

    
//    [self.searchImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self);
//        make.left.equalTo(self).offset(10);
//        make.width.equalTo(@16);
//    }];
    

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self);
        self.collectionViewWidth = make.width.equalTo(@(30));
//        make.right.lessThanOrEqualTo(self).offset(-100);
        make.right.equalTo(self);

    }];
    
//    [self.searchTextfield mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.collectionView.mas_right).offset(4);
//        make.centerY.right.equalTo(self);
//    }];

    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
}


- (void)addPeople:(NSArray *)people {
    if (![people count]) {
        return;
    }
    NSInteger originalCount = [[self mutableArrayValueForKey:@"arraySelect"] count];
    [[self mutableArrayValueForKey:@"arraySelect"] addObjectsFromArray:people];
    NSMutableArray *arrayIndexPathInsert = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [people count]; i ++) {
        [arrayIndexPathInsert addObject:[NSIndexPath indexPathForItem:i + originalCount inSection:0]];
    }
    
    [self.collectionView insertItemsAtIndexPaths:arrayIndexPathInsert];
    [self UIRefresh];
}

- (void)deletePeople:(NSArray *)people {
    NSMutableArray *arrayIndexPathDelete = [NSMutableArray array];
    
    NSMutableArray *arraySelectedNeedChanged = [NSMutableArray arrayWithArray:[self mutableArrayValueForKey:@"arraySelect"]];
    NSDictionary *dictSelect = [self getShowIdDictionaryFromArray:people];
    
    for (NSInteger i = 0; i < [self mutableArrayValueForKey:@"arraySelect"].count;i ++) {
        id cellData = [[self mutableArrayValueForKey:@"arraySelect"] objectAtIndex:i];
        NSString *uid = @"";
        if ([cellData isKindOfClass:[ContactInfoModel class]]) {
            uid = ((ContactInfoModel *)cellData).relationInfoModel.relationName;
        }
        else if ([cellData isKindOfClass:[PatientInfo class]]) {
            uid = [NSString stringWithFormat:@"%ld",((PatientInfo *)cellData).userId];

        }

        if (![dictSelect objectForKey:uid]) {
            continue;
        }
        
        [arraySelectedNeedChanged removeObject:[self mutableArrayValueForKey:@"arraySelect"][i]];
        [arrayIndexPathDelete addObject:[NSIndexPath indexPathForItem:i inSection:0]];
    }
    
    if (![arrayIndexPathDelete count]) {
        return;
    }
    
    self.arraySelect = arraySelectedNeedChanged;
    [self.collectionView deleteItemsAtIndexPaths:arrayIndexPathDelete];
    [self UIRefresh];
}

//删除指定indexPath的方法
- (void)deleteSelectedPeopleWithIndexPath:(NSIndexPath *)indexPath
{

    id cellData = self.arraySelect[indexPath.row];
    [[self mutableArrayValueForKey:@"arraySelect"] removeObjectAtIndex:indexPath.row];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    [self UIRefresh];
    self.deleteHandler(cellData);
}

- (void)UIRefresh
{
    if ([[self mutableArrayValueForKey:@"arraySelect"] count] == 0) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[[self mutableArrayValueForKey:@"arraySelect"] count] - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    return; // 不需要搜索
    
//    [self.searchImageView setHidden:[self mutableArrayValueForKey:@"arraySelect"].count > 0];

    if ([ [ UIScreen mainScreen ] bounds ].size.width - 100 > (ROWHEIGHT + 6) * [self mutableArrayValueForKey:@"arraySelect"].count)
    {
        if ([self mutableArrayValueForKey:@"arraySelect"].count) {
            self.collectionViewWidth.offset = (ROWHEIGHT + 6) * [self mutableArrayValueForKey:@"arraySelect"].count;
        } else {
            self.collectionViewWidth.offset = 30;
        }
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf layoutIfNeeded];
        }];
    }

}

- (NSDictionary *)getShowIdDictionaryFromArray:(NSArray *)array
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (int i = 0; i < array.count; i++) {
        id cellData = array[i];
        NSString *uid = @"";
        if ([cellData isKindOfClass:[ContactInfoModel class]]) {
            uid = ((ContactInfoModel *)cellData).relationInfoModel.relationName;
        }
        else if ([cellData isKindOfClass:[PatientInfo class]]) {
            uid = [NSString stringWithFormat:@"%ld",((PatientInfo *)cellData).userId];
            
        }

        [dict setObject:@"1" forKey:uid];
    }
    return dict;
    
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UICollectionView Delegate & DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[self mutableArrayValueForKey:@"arraySelect"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectContactCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SelectContactCollectionViewCell identifier] forIndexPath:indexPath];
    id cellData = [[self mutableArrayValueForKey:@"arraySelect"] objectAtIndex:indexPath.row];
    NSString *avatarPath = @"";
    
    if ([cellData isKindOfClass:[ContactInfoModel class]]) {
        avatarPath = ((ContactInfoModel *)cellData).relationInfoModel.relationAvatar;
        if (avatarPath.length == 0) {
            UserProfileModel *fullModel = [[MessageManager share] queryContactProfileWithUid:((ContactInfoModel *)cellData).relationInfoModel.relationName];
            avatarPath = fullModel.avatar;
        }
    }
    else if ([cellData isKindOfClass:[PatientInfo class]]) {
        avatarPath = ((PatientInfo *)cellData).imgUrl;
    }
    [cell configCellImageViewWithImagePath:avatarPath];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteSelectedPeopleWithIndexPath:indexPath];
}

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface

#pragma mark - init UI

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(30, 30);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[SelectContactCollectionViewCell class] forCellWithReuseIdentifier:[SelectContactCollectionViewCell identifier]];
    }
    return _collectionView;
}

/*
- (UIImageView *)searchImageView
{
    if (!_searchImageView) {
        _searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchImage"]];
    }
    return _searchImageView;
}

- (UITextField *)searchTextfield
{
    if (!_searchTextfield) {
        _searchTextfield = [[UITextField alloc]init];
        [_searchTextfield setPlaceholder:@"搜索"];
        
    }
    return _searchTextfield;
}
*/

- (NSMutableArray *)arraySelect
{
    if (!_arraySelect) {
        _arraySelect = [NSMutableArray new];
    }
    return  _arraySelect;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [UIView new];
        [_bottomLine setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    }
    return _bottomLine;
}
@end

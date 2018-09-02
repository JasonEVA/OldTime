//
//  ChatGroutAvatarsTableViewCell.m
//  launcher
//
//  Created by Andrew Shen on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatGroutAvatarsTableViewCell.h"
#import "ChatGroupManagerCollectionViewCell.h"
#import <Masonry.h>

static NSString * const identifier = @"cell";
CGFloat const interitemSpacing = 7;
CGFloat const lineSpacing = 4;
CGFloat const collectionCellWidth = 70;
CGFloat const collectionCellheight = 90;

@interface ChatGroutAvatarsTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)  UICollectionView  *collectionView; // <##>
@property (nonatomic, strong)  NSMutableArray  *arrayPersons; // <##>
@property (nonatomic)  BOOL  deleteState; // <##>
@property (nonatomic)  BOOL  isHost; // 是否是群主
@end

@implementation ChatGroutAvatarsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (void)setPersonData:(NSArray *)arrayPerson isHost:(BOOL)isHost {
    self.isHost = isHost;
    [self.arrayPersons removeAllObjects];
    [self.arrayPersons addObjectsFromArray:arrayPerson];
    if (self.arrayPersons.count != 0)
    {
        [self.arrayPersons addObjectsFromArray:(isHost ? @[@"",@""] : @[@""])];
    }
    [self.collectionView reloadData];
}
- (void)addPerson {
    if (self.deleteState) {
        self.deleteState = !self.deleteState;
        [self.collectionView reloadData];

    }
    
    if ([self.delegate respondsToSelector:@selector(ChatGroutAvatarsTableViewCellDelegateCallBack_addPeople)]) {
        [self.delegate ChatGroutAvatarsTableViewCellDelegateCallBack_addPeople];
    }
}

- (void)deletePersonClick {
    self.deleteState = !self.deleteState;
    [self.collectionView reloadData];
}

- (void)deletePersonWithProfile:(UserProfileModel *)model {
    
    if ([self.delegate respondsToSelector:@selector(ChatGroutAvatarsTableViewCellDelegateCallBack_deletePeopleWithProfile:)]) {
        [self.delegate ChatGroutAvatarsTableViewCellDelegateCallBack_deletePeopleWithProfile:model];
    }

}

- (void)personDetailClickedWithProfile:(UserProfileModel *)model {
    if ([self.delegate respondsToSelector:@selector(ChatGroutAvatarsTableViewCellDelegateCallBack_personDetailClicked:)])
    {
        [self.delegate ChatGroutAvatarsTableViewCellDelegateCallBack_personDetailClicked:model];
    }
}

#pragma mark - Init
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = interitemSpacing; // 列间距
        layout.minimumLineSpacing = lineSpacing; // 行间距
        layout.sectionInset = UIEdgeInsetsMake(18, 13, 18, 13);
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[ChatGroupManagerCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setScrollEnabled:NO];
    }
    return _collectionView;
}

- (NSMutableArray *)arrayPersons {
    if (!_arrayPersons) {
        _arrayPersons = [NSMutableArray array];
    }
    return _arrayPersons;
}
#pragma mark - UICollectionView Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayPersons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatGroupManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    [cell deserveDeleteEvent:^(NSIndexPath *cellIndexPath) {
        // 删除数据
        [self deletePersonWithProfile:self.arrayPersons[cellIndexPath.row]];
//        [self.arrayPersons removeObjectAtIndex:cellIndexPath.row];
//        [self.collectionView reloadData];
    }];
    if (indexPath.row == 0) {
        cell.tag = avatar_host;
    } else if (indexPath.row == self.arrayPersons.count - 2 && self.isHost) {
        cell.tag = avatar_add;
    
    } else if (indexPath.row == self.arrayPersons.count - 1) {
        if (self.isHost) {
            cell.tag = avatar_delete;
        } else {
            cell.tag = avatar_add;
        }
    
    } else {
        cell.tag = avatar_others;
    }
    [cell avatarEdit:self.deleteState];
    [cell setAvatarData:self.arrayPersons[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatGroupManagerCollectionViewCell *cell = (ChatGroupManagerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    switch (cell.tag) {
        case avatar_add:
            [self addPerson];
            break;
            
        case avatar_delete:
            [self deletePersonClick];
            break;

        default:
            [self personDetailClickedWithProfile:self.arrayPersons[indexPath.item]];
            break;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionCellWidth, collectionCellheight);
}

@end

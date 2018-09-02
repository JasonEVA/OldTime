//
//  MissionNavBar.m
//  launcher
//
//  Created by Kyle He on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MissionNavBar.h"
#import <Masonry/Masonry.h>
#import "MissionNavCollectionViewCell.h"
#import "TaskWhiteBoardModel.h"
#import "UIColor+Hex.h"
#import "GetWhiteBoardListRequest.h"

static NSString * newString = @"Todo";

@interface MissionNavBar ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BaseRequestDelegate>

@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) UIButton         *addButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) NSArray *titleArray;
/** 记录下被选中的序号 */
@property (nonatomic, assign) NSString *selectedWhiteboardShowId;

/** 纪录下projectShowId，为空时只显示new状态 */
@property (nonatomic, copy) NSString *projectShowId;
@property (nonatomic, copy) NSString *currenWhiteBoardId;

@property (nonatomic, strong) NSMutableArray *arrayLabelSize;

@end

@implementation MissionNavBar

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:MissionNavBarStyleDefault];
}

- (instancetype)initWithFrame:(CGRect)frame style:(MissionNavBarStyle)style {
    self = [super initWithFrame:frame];
    if (self) {
        _style = style;
        [self initComponents];
    }
    return self;
}

- (void)initComponents {
    [self addSubview:self.collectView];
    if (self.style == MissionNavBarStyleWithoutAdd) {
        self.collectView.backgroundColor = [UIColor mtc_colorWithHex:0xf1f1f1];
        [self.collectView setTransform:CGAffineTransformMakeRotation(M_PI)];
    }

    if (self.style == MissionNavBarStyleDefault) {
        [self addSubview: self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(self);
            make.width.height.equalTo(self.mas_height);
        }];
    }
   
    [self.collectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        if (self.style == MissionNavBarStyleWithoutAdd) {
            make.right.equalTo(self);
        } else {
            make.right.equalTo(self.addButton.mas_left);
        }
    }];
}

#pragma mark - Interface Method
- (void)showWithProjectId:(NSString *)showId {
    self.titleArray = @[];
    [self.collectView reloadData];
    self.projectShowId = showId;
    
    if ([self justShowNew]) {
        return;
    }
    
    GetWhiteBoardListRequest *listRequest = [[GetWhiteBoardListRequest alloc] initWithDelegate:self];
    [listRequest getProjectWhiteBoard:showId];
}

- (void)updateWhiteboard:(NSArray *)whiteboard {
    self.titleArray = whiteboard;
    [self.collectView reloadData];
}

- (void)showWithArray:(NSArray *)whiteBoards currentWhiteBoardId:(NSString *)currentWhiteBoardId {
    self.titleArray = [[whiteBoards reverseObjectEnumerator] allObjects];
    self.currenWhiteBoardId = currentWhiteBoardId;
    
    if (![self.titleArray count]) {
        [self addSubview:self.activityView];
        [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
        }];
        
        [self.activityView startAnimating];
        return;
    }
    
    if ([self.activityView isAnimating]) {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        self.activityView = nil;
    }
    
    for (NSInteger i = 0; i < self.titleArray.count; i ++) {
        TaskWhiteBoardModel *whiteBoardModel = [self.titleArray objectAtIndex:i];
        if (![whiteBoardModel.showId isEqualToString:currentWhiteBoardId]) {
            continue;
        }
        
        self.selectedWhiteboardShowId = whiteBoardModel.showId;
        [self.collectView reloadData];
        break;
    }
}

#pragma mark - Private Method
- (BOOL)justShowNew {
    return (!self.projectShowId || ![self.projectShowId length]) && !self.currenWhiteBoardId;
}

#pragma mark - Button Click
- (void)selectAction {
    if ([self.delegate respondsToSelector:@selector(missionNavBar:refreshWithSelectedWhiteBoard:)]) {
        TaskWhiteBoardModel *whiteBoardModel;
        for (TaskWhiteBoardModel *model in self.titleArray) {
            if ([model.showId isEqualToString:self.selectedWhiteboardShowId]) {
                whiteBoardModel = model;
                break;
            }
        }
        
        [self.delegate  missionNavBar:self refreshWithSelectedWhiteBoard:whiteBoardModel];
    }
}

- (void)showWhiteBoard {
    if ([self.delegate respondsToSelector:@selector(missionNavBarShowEditVC:)]) {
        [self.delegate missionNavBarShowEditVC:self];
    }
}

#pragma mark - Request Delegate
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    if ([request isKindOfClass:[GetWhiteBoardListRequest class]]) {
        NSArray *arrayTmp = [(GetWhiteBoardListResponse *)response arrayWhiteBoard];
        self.titleArray = [NSArray arrayWithArray:arrayTmp];
        
        if (self.style == MissionNavBarStyleWithoutAdd) {
            self.titleArray = [[arrayTmp reverseObjectEnumerator] allObjects];
        }
        [self.collectView reloadData];
        
        for (TaskWhiteBoardModel *model in arrayTmp) {
            if (model.style == whiteBoardStyleWaiting) {
                newString = model.title;
                self.selectedWhiteboardShowId = model.showId;
                break;
            }
        }
        
        [self selectAction];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    if ([self.delegate respondsToSelector:@selector(missionNavBarShowFailed:)]) {
        [self.delegate missionNavBarShowFailed:errorMessage];
    }
}

#pragma mark - collectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self justShowNew]) {
        return 1;
    }
    
    return self.titleArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleString = @"";
    if ([self justShowNew]) {
        titleString = newString;
    }
    else {
        TaskWhiteBoardModel *model = self.titleArray[indexPath.row];
        titleString = model.title;
    }
    
    CGSize titleSize = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}];
    CGFloat width = titleSize.width;
    if (width < 15) {
        width = 15;
    }
    
    return CGSizeMake(width, self.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.titleArray.count == 0) {
        return self.frame.size.width / (self.titleArray.count + 1);
    }
    return 50.0f;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MissionNavCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MissionNavCollectionViewCell identifier] forIndexPath:indexPath];
    if (self.style == MissionNavBarStyleWithoutAdd) {
        [cell setTransform:CGAffineTransformMakeRotation(M_PI)];
    }
    
    if ([self justShowNew]) {
        [cell titleLbl].text = newString;
        cell.selected = YES;
    }
    
    else {
        TaskWhiteBoardModel *model = self.titleArray[indexPath.row];
        cell.titleLbl.text = model.title;
        cell.selected = [model.showId isEqualToString:self.selectedWhiteboardShowId];
    }
    

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.titleArray count] <= indexPath.row) {
        return;
    }
    TaskWhiteBoardModel *model = [self.titleArray objectAtIndex:indexPath.row];
    if ([self.selectedWhiteboardShowId isEqualToString:model.showId]) {
        return;
    }
    // 更新选中后model标记
    model.selected = YES;
    
    NSInteger index = 0;
    for (TaskWhiteBoardModel *model in self.titleArray) {
        if ([model.showId isEqualToString:self.selectedWhiteboardShowId]) {
            index = [self.titleArray indexOfObject:model];
            break;
        }
    }
    NSIndexPath *indexPathOriginal = [NSIndexPath indexPathForItem:index inSection:0];
    
    self.selectedWhiteboardShowId = model.showId;
    [self.collectView reloadItemsAtIndexPaths:@[indexPathOriginal, indexPath]];
    [self selectAction];
}

#pragma mark - getter and setter

- (UICollectionView *)collectView
{
    if (!_collectView)
    {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectView  = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:flowlayout];
        _collectView.backgroundColor = [UIColor whiteColor];
        _collectView.showsHorizontalScrollIndicator = NO;
        
        _collectView.delegate = self;
        _collectView.dataSource = self;
        
        [_collectView registerClass:[MissionNavCollectionViewCell class] forCellWithReuseIdentifier:[MissionNavCollectionViewCell identifier]];
    }
    return _collectView;
}

@synthesize titleArray = _titleArray;
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}

- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = [NSArray arrayWithArray:titleArray];
    BOOL moveToFirstTitle = YES;
    for (TaskWhiteBoardModel *model in _titleArray) {
        if ([model.showId isEqualToString:self.selectedWhiteboardShowId]) {
            moveToFirstTitle = NO;
            break;
        }
    }
    
    if (moveToFirstTitle) {
        TaskWhiteBoardModel *model = [_titleArray firstObject];
        self.selectedWhiteboardShowId = model.showId;
        if (self.style == MissionNavBarStyleDefault && model) {
            // 如果当前的白板被删除，则跳转到toDO
            [self selectAction];
        }
    }
    
    [self.collectView reloadData];
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage imageNamed:@"Mission_add"] forState:UIControlStateNormal];
        [_addButton setBackgroundColor:[UIColor whiteColor]];
        [_addButton addTarget:self action:@selector(showWhiteBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [UIActivityIndicatorView new];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _activityView;
}

@end

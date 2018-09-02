//
//  TaskWhiteBoardViewController.m
//  launcher
//
//  Created by William Zhang on 15/9/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "TaskWhiteBoardViewController.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "TaskWhiteBoardCollectionViewCell.h"
#import "updateWhiteboardSortRequest.h"
#import "UpdateWhiteboardNameRequest.h"
#import "GetWhiteBoardListRequest.h"
#import "DeleteWhiteboardRequest.h"
#import "CreateWhiteboardRequest.h"
#import "TaskWhiteBoardModel.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface TaskWhiteBoardViewController () <LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout, UIAlertViewDelegate, UIGestureRecognizerDelegate, BaseRequestDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITapGestureRecognizer *stopAnimateGesture;

@property (nonatomic, strong) NSMutableArray *arrayModel;
@property (nonatomic, copy) whiteBoardSaveBlock saveBlock;

@property (nonatomic, assign) BOOL isDragging;

@property (nonatomic, copy) NSString *projectId;

@end

@implementation TaskWhiteBoardViewController

- (instancetype)initWithProjectId:(NSString *)projectShowId finished:(whiteBoardSaveBlock)finishedBlock {
    self = [super init];
    if (self) {
        _projectId = projectShowId;
        _saveBlock = finishedBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(MISSION_EDITWHITEBOARD);
//    UIImage *imageRightItem = [[UIImage imageNamed:@"Calendar_check"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:imageRightItem style:UIBarButtonItemStylePlain target:self action:@selector(clickToSave)];
//    [self.navigationItem setRightBarButtonItem:rightItem];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:LOCAL(CANCEL) style:UIBarButtonItemStylePlain target:self action:@selector(clickToBack)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self postLoading];
    GetWhiteBoardListRequest *request = [[GetWhiteBoardListRequest alloc] initWithDelegate:self];
    [request getProjectWhiteBoard:self.projectId];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    !self.saveBlock ?: self.saveBlock(self.arrayModel);
}

#pragma mark - Button Click
- (void)clickToSave {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)clickToBack {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)stopAnimation {
    self.isDragging = NO;
    [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.1];
    [self.collectionView performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

#pragma mark - Private Method
- (void)deleteWhiteBoardAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }
    
    TaskWhiteBoardModel *deleteModel = [self.arrayModel objectAtIndex:indexPath.row];
    DeleteWhiteboardRequest *deleteRequest = [[DeleteWhiteboardRequest alloc] initWithDelegate:self identifier:indexPath.row];
    [deleteRequest deleteWhiteboardShowId:deleteModel.showId];
    [self postLoading];
}

- (void)editWhiteBoard:(NSString *)editedString itemAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) {
        return;
    }

    if (![editedString length]) {
        [self postError:LOCAL(APPLY_INPUT_TITLE)];
        return;
    }
    
    NSInteger row = indexPath.row;
    TaskWhiteBoardModel *model = [self.arrayModel objectAtIndex:row];

    if ([model.title isEqualToString:editedString]) {
        return;
    }
    
    UpdateWhiteboardNameRequest *updateNameRequest = [[UpdateWhiteboardNameRequest alloc] initWithDelegate:self identifier:row];
    [updateNameRequest updateName:editedString showId:model.showId];
    [self postLoading];
}

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    }
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *whiteboardName = textField.text;
    if (![whiteboardName length]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"该输入框不能为空" message:nil delegate:nil cancelButtonTitle:LOCAL(CONFIRM) otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    CreateWhiteboardRequest *createRequest = [[CreateWhiteboardRequest alloc] initWithDelegate:self];
    [createRequest newWhiteboardName:whiteboardName fromProjectId:self.projectId];
    [self postLoading];
}

#pragma mark - BaseRequest Delegate & DataSource
- (void)requestSucceeded:(BaseRequest *)request response:(BaseResponse *)response totalCount:(NSInteger)totalCount {
    [self hideLoading];
    if ([request isKindOfClass:[GetWhiteBoardListRequest class]]) {
        NSArray *array = [(id)response arrayWhiteBoard];
        self.arrayModel = [NSMutableArray arrayWithArray:array];
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        [self.collectionView reloadData];
    }
    
    else if ([request isKindOfClass:[CreateWhiteboardRequest class]]) {
        TaskWhiteBoardModel *newModel = [(id)response whiteboardModel];
        
        NSInteger modelCount = [self.arrayModel count];
        
        [self.arrayModel insertObject:newModel atIndex:(modelCount == 0 ? 0 : modelCount - 1)];
        [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:(modelCount < 1 ? 0 : modelCount - 1) inSection:0]]];
    }
    
    else if ([request isKindOfClass:[DeleteWhiteboardRequest class]]) {
        NSInteger index = request.identifier;
        [self.arrayModel removeObjectAtIndex:index];
        [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
    }
    
    else if ([request isKindOfClass:[UpdateWhiteboardNameRequest class]]) {
        NSString *updatedName = [(id)request updatedName];
        NSInteger row = request.identifier;
        TaskWhiteBoardModel *updatedModel = [self.arrayModel objectAtIndex:row];
        updatedModel.title = updatedName;
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]];
    }
}

- (void)requestFailed:(BaseRequest *)request errorMessage:(NSString *)errorMessage {
    [self postError:errorMessage];
    
    if ([request isKindOfClass:[updateWhiteboardSortRequest class]]) {
        NSInteger fromIndex = [(id)request fromIndex];
        NSInteger toIndex   = [(id)request toIndex];
        
        TaskWhiteBoardModel *model = [self.arrayModel objectAtIndex:toIndex];
        
        [self.arrayModel removeObjectAtIndex:toIndex];
        [self.arrayModel insertObject:model atIndex:fromIndex];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:fromIndex inSection:0],
                                                       [NSIndexPath indexPathForRow:toIndex inSection:0]]];
    }
    else if ([request isKindOfClass:[UpdateWhiteboardNameRequest class]]) {
        NSInteger index = request.identifier;
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    }
}

#pragma mark - UICollectionView Delegate & DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayModel.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TaskWhiteBoardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[TaskWhiteBoardCollectionViewCell identifier] forIndexPath:indexPath];
    
    [cell clickDelete:^(TaskWhiteBoardCollectionViewCell *collectionViewCell) {
        // 删除
        NSIndexPath *deleteIndexPath = [collectionView indexPathForCell:collectionViewCell];
        [self deleteWhiteBoardAtIndexPath:deleteIndexPath];
    } edit:^(TaskWhiteBoardCollectionViewCell *collectionViewCell, NSString *editedString) {
        // 编辑文字后
        NSIndexPath *didEditIndexPath = [collectionView indexPathForCell:collectionViewCell];
        [self editWhiteBoard:editedString itemAtIndexPath:didEditIndexPath];
    }];
    
    NSInteger row = indexPath.row;

    cell.canDelete = self.isDragging;
    cell.canEdit = self.isDragging;
    cell.newWhite = NO;
    
    NSString *titleString = @"";
    if (row == [self.arrayModel count]) {
        cell.canDelete = NO;
        cell.canEdit = NO;
        cell.newWhite = YES;
        titleString = LOCAL(MISSION_NEWBOARD);
    }
    else {
        TaskWhiteBoardModel *model = [self.arrayModel objectAtIndex:row];
        titleString = model.title;
        
        if (model.style != whiteBoardStyleInProgress) {
            cell.canDelete = NO;
            cell.canEdit = NO;
        }
    }
    
    [cell setTitle:titleString];
    [cell shakeShake:self.isDragging];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.arrayModel.count) {
        // 新的白板
        [self dismissKeyboard];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCAL(MISSION_INPUTWHITEBOARDTITLE) message:nil delegate:self cancelButtonTitle:LOCAL(CANCEL) otherButtonTitles:LOCAL(CONFIRM), nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView show];
        
        self.isDragging = NO;
        [self.collectionView reloadData];
    }
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    NSInteger fromRow = fromIndexPath.row;;
    NSInteger toRow   = toIndexPath.row;
    TaskWhiteBoardModel *model = [self.arrayModel objectAtIndex:fromRow];
    
    [self.arrayModel removeObjectAtIndex:fromRow];
    [self.arrayModel insertObject:model atIndex:toRow];
    
    [self postLoading];
    updateWhiteboardSortRequest *updateSortRequest = [[updateWhiteboardSortRequest alloc] initWithDelegate:self];
    [updateSortRequest beforeUpdateIndex:fromRow toIndex:toRow];
    
    TaskWhiteBoardModel *preModel = [self.arrayModel objectAtIndex:toRow - 1];
    
    [updateSortRequest updateWhiteboardSort:model.showId previousBoardShowId:preModel.showId];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row == [self.arrayModel count]) {
        return NO;
    }
    
    TaskWhiteBoardModel *model = self.arrayModel[row];
    if (model.style != whiteBoardStyleInProgress) {
        return NO;
    }
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    return [self collectionView:collectionView canMoveItemAtIndexPath:toIndexPath];
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    self.isDragging = YES;
    for (TaskWhiteBoardCollectionViewCell *visibleCell in collectionView.visibleCells) {
        [visibleCell shakeShake:YES];
        NSIndexPath *indexPath = [collectionView indexPathForCell:visibleCell];
        if (indexPath.row == [self.arrayModel count]) {
            continue;
        }
        
        TaskWhiteBoardModel *model = [self.arrayModel objectAtIndex:indexPath.row];
        if (model.style == whiteBoardStyleInProgress) {
            [visibleCell setCanDelete:YES];
        }
    }
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.collectionView) {
        return NO;
    }
    return YES;
}

#pragma mark - Initializer
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        LXReorderableCollectionViewFlowLayout *flowLayout = [[LXReorderableCollectionViewFlowLayout alloc] init];
        CGFloat width = (CGRectGetWidth(self.view.frame) - (15 * 6)) / 3;
        flowLayout.itemSize = CGSizeMake(width, width);
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[TaskWhiteBoardCollectionViewCell class] forCellWithReuseIdentifier:[TaskWhiteBoardCollectionViewCell identifier]];

        self.stopAnimateGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopAnimation)];
        self.stopAnimateGesture.delegate =  self;
        [_collectionView addGestureRecognizer:self.stopAnimateGesture];
    }
    return _collectionView;
}

- (NSMutableArray *)arrayModel {
    if (!_arrayModel) {
        _arrayModel = [NSMutableArray array];
    }
    return _arrayModel;
}

@end

//
//  ASPhotosGridViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ASPhotosGridViewController.h"
#import <Photos/Photos.h>
#import "WZPhotoThumbnailCollectionViewCell.h"
#import "WZPhotoPickerController.h"
#import "UIView+Util.h"
#import "UIImage+EX.h"

static CGSize AssetGridThumbnailSize;

@interface ASPhotosGridViewController () <UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel  *selectCountLabel;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong)  PHFetchResult<PHAsset *>  *fetchResult; // <##>
@property (nonatomic, strong)  PHAssetCollection  *collection; // <##>
@property (nonatomic, strong)  NSMutableArray<PHAsset *>  *arraySelected; // <##>
@property (nonatomic, strong)  NSIndexPath  *lastSelectedIndexPath; // <##>

@end

@implementation ASPhotosGridViewController

- (void)dealloc
{
    NSLog(@"-------------->PhotoPickerDealloc");
}

- (instancetype)initWithAssetCollection:(PHAssetCollection *)collection {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _collection = collection;
        self.fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self.collectionView registerClass:[WZPhotoThumbnailCollectionViewCell class] forCellWithReuseIdentifier:[WZPhotoThumbnailCollectionViewCell identifier]];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.title = self.collection.localizedTitle;
    self.collectionView.allowsMultipleSelection = self.pickerController.allowMutipleSelection;
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.0];

    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);

    // 设置数据
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置数据
- (void)configData {
    
}

// 设置约束
- (void)configConstraints {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectCountLabel];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self configToolbar];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];

}

// 设置toolbar
- (void)configToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithCustomView:self.doneButton];
    self.doneButton.enabled = NO;
    [toolbar setItems:@[space,done]];
    [self.view addSubview:toolbar];
    
    [toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@49);
    }];
}

- (void)updateDoneButtonState {
    NSUInteger selectedCount = [self.arraySelected count];
    
    [self.doneButton setEnabled:selectedCount > 0];
    [self.selectCountLabel setText:[NSString stringWithFormat:@"%ld/%ld",selectedCount, self.pickerController.maximumNumberOfSelection]];
}

- (void)scrollToBottom {
    if (!self.fetchResult.count) {
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.fetchResult count] - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
}

#pragma mark - Event Response

- (void)clickToDone {
    if (self.pickerController.photoPickerHandler) {
        NSMutableArray *arrayImages = [NSMutableArray array];
        NSInteger imagesCount = self.arraySelected.count;
        __weak typeof(self) weakSelf = self;
        [self.arraySelected enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[PHImageManager defaultManager] requestImageForAsset:obj targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                [arrayImages addObject:result];
                if (arrayImages.count == imagesCount) {
                    weakSelf.pickerController.photoPickerHandler(arrayImages);
                    weakSelf.pickerController.photoPickerHandler = nil;
                }
            }];
        }];

    }
    [self.pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.fetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZPhotoThumbnailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[WZPhotoThumbnailCollectionViewCell identifier] forIndexPath:indexPath];
    
    PHAsset *asset = self.fetchResult[indexPath.item];

    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:AssetGridThumbnailSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.imageView.image = result;
    }];
    [cell setSelected:[self.arraySelected containsObject:asset]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfColunms = 4;
    CGFloat width = (CGRectGetWidth(self.view.frame) - 2.0 * (numberOfColunms + 1)) / numberOfColunms;
    return CGSizeMake(width, width);
}

#pragma mark - UICollectionView Delegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.pickerController.allowMutipleSelection) {
        return YES;
    }
    
    return self.arraySelected.count < self.pickerController.maximumNumberOfSelection;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((!self.pickerController.allowMutipleSelection || self.pickerController.maximumNumberOfSelection == 1) && self.lastSelectedIndexPath) {
        [collectionView deselectItemAtIndexPath:self.lastSelectedIndexPath animated:NO];
    }
    self.lastSelectedIndexPath = indexPath;
    PHAsset *asset = self.fetchResult[indexPath.item];
    [self.arraySelected addObject:asset];
    [self updateDoneButtonState];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.lastSelectedIndexPath = nil;
    PHAsset *asset = self.fetchResult[indexPath.item];
    [self.arraySelected removeObject:asset];
    [self updateDoneButtonState];
}

#pragma mark - Override

#pragma mark - Init

- (NSMutableArray<PHAsset *> *)arraySelected {
    if (!_arraySelected) {
        _arraySelected = [NSMutableArray array];
    }
    return _arraySelected;
}

- (UILabel *)selectCountLabel {
    if (!_selectCountLabel) {
        _selectCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
        _selectCountLabel.text = [NSString stringWithFormat:@"0/%ld",self.pickerController.maximumNumberOfSelection];
        _selectCountLabel.font = [UIFont systemFontOfSize:15];
        _selectCountLabel.textColor = [UIColor whiteColor];
        _selectCountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _selectCountLabel;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
        
        [_doneButton setBackgroundImage:[UIImage at_imageWithColor:[UIColor mainThemeColor] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_doneButton setTitle:@"发送" forState:UIControlStateNormal];
        _doneButton.expandSize = CGSizeMake(20, 10);
        
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:13];
        _doneButton.layer.cornerRadius = 3.0;
        [_doneButton setClipsToBounds:YES];
        [_doneButton addTarget:self action:@selector(clickToDone) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

@end

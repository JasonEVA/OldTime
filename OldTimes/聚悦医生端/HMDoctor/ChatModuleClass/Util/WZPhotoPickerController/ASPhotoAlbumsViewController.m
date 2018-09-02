//
//  ASPhotoAlbumsViewController.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ASPhotoAlbumsViewController.h"
#import <Photos/Photos.h>
#import "ASPhotosGridViewController.h"

static const CGFloat kCellHeight = 90;

@interface ASPhotoAlbumsTableViewCell : UITableViewCell
@property (nonatomic, strong)  UIImageView  *imgView; // <##>
@property (nonatomic, strong)  UILabel  *title; // <##>
@end

@implementation ASPhotoAlbumsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [UIImageView new];
        self.title = [UILabel new];
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.title];
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 10, 10, 0));
            make.width.equalTo(self.imgView.mas_height).priorityHigh();
        }];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.imgView.mas_right).offset(10);
        }];
    }
    return self;
}

@end

@interface ASPhotoAlbumsViewController ()<PHPhotoLibraryChangeObserver>
@property (nonatomic, strong)  NSMutableArray<PHAssetCollection *>  *arrayCollection; // <##>
@property (nonatomic, strong)  PHFetchResult<PHAssetCollection *>  *fetchResult; // <##>
@end

@implementation ASPhotoAlbumsViewController

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configElements];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    self.title = @"相册";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(clickToDismiss)];
    self.navigationItem.leftBarButtonItem = leftItem;

    [self.tableView registerClass:[ASPhotoAlbumsTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ASPhotoAlbumsTableViewCell class])];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // 设置数据
    [self configData];
}

// 设置数据
- (void)configData {
    [self p_configAlbums];
}


// 设置相册
- (void)p_configAlbums {
    // 相机胶卷
    PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary  options:nil];
    // 自定义相册
    PHFetchResult<PHAssetCollection *> *customAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular  options:nil];
    __weak typeof(self) weakSelf = self;
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchKeyAssetsInAssetCollection:obj options:nil];

        if (fetchResult.count > 0) {
            [strongSelf.arrayCollection addObject:obj];
        }
    }];
    [customAlbums enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchKeyAssetsInAssetCollection:obj options:nil];
        if (fetchResult.count > 0) {
            [strongSelf.arrayCollection addObject:obj];
        }
    }];
    self.fetchResult = smartAlbums;
    if (self.arrayCollection.count) {
        [self goPhotoGridViewControllerWithAssetCollection:self.arrayCollection.firstObject pushAnimated:NO];
    }
    [self.tableView reloadData];
}

#pragma mark - Event Response

- (void)clickToDismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Delegate

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Loop through the section fetch results, replacing any fetch results that have been updated.
        BOOL reloadRequired = NO;
        PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:self.fetchResult];
        if (changeDetails != nil) {
            self.fetchResult = [changeDetails fetchResultAfterChanges];
            [self.arrayCollection removeAllObjects];
            __weak typeof(self) weakSelf = self;
            [self.fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchKeyAssetsInAssetCollection:obj options:nil];
                
                if (fetchResult.count > 0) {
                    [strongSelf.arrayCollection addObject:obj];
                }
            }];
            reloadRequired = YES;
        }
        if (reloadRequired) {
            [self.tableView reloadData];
        }
        
    });
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayCollection count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASPhotoAlbumsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ASPhotoAlbumsTableViewCell class]) forIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    PHAssetCollection *collection = self.arrayCollection[indexPath.row];
    cell.title.text = collection.localizedTitle;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat imageWidth = kCellHeight * scale;
    CGSize imageSize = CGSizeMake(imageWidth, imageWidth);

    PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchKeyAssetsInAssetCollection:collection options:nil];
    [[PHImageManager defaultManager] requestImageForAsset:fetchResult.firstObject targetSize:imageSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.imgView.image = result;
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PHAssetCollection *collection = self.arrayCollection[indexPath.row];
    [self goPhotoGridViewControllerWithAssetCollection:collection pushAnimated:YES];
}

- (void)goPhotoGridViewControllerWithAssetCollection:(PHAssetCollection *)collection pushAnimated:(BOOL)animated {
    ASPhotosGridViewController *photosViewController = [[ASPhotosGridViewController alloc] initWithAssetCollection:collection];
    photosViewController.pickerController = self.pickerController;
    [self.navigationController pushViewController:photosViewController animated:animated];
}

#pragma mark - Override

#pragma mark - Init

- (NSMutableArray<PHAssetCollection *> *)arrayCollection {
    if (!_arrayCollection) {
        _arrayCollection = [NSMutableArray array];
    }
    return _arrayCollection;
}

@end

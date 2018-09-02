//
//  MeBodilyFormViewController.m
//  Shape
//
//  Created by Andrew Shen on 15/11/13.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeBodilyFormViewController.h"
#import <Masonry/Masonry.h>
#import "UIColor+Hex.h"
#import "MyDefine.h"
#import "MeGridCollectionViewCell.h"
#import "MePageCollectionViewCell.h"
static NSString *const kGridCell = @"gridCell";
static NSString *const kPageCell = @"pageCell";

@interface MeBodilyFormViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)  UIButton  *btnRecord; // <##>
@property (nonatomic, strong)  UICollectionView  *collectionView; // 滑动背景
@property (nonatomic, strong)  UICollectionViewFlowLayout  *gridFlowLayout; // <##>
@property (nonatomic, strong)  UICollectionViewFlowLayout  *pageFlowLayout; // <##>
@property (nonatomic, strong)  UIBarButtonItem  *layoutItem; // <##>
@end

@implementation MeBodilyFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"体型"];
    
    [self.navigationItem setRightBarButtonItem:self.layoutItem];
    [self configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints {
    [self.btnRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(height_49));
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.btnRecord.mas_top);
    }];
    [super updateViewConstraints];
}

#pragma mark - Private Method

// 设置元素控件
- (void)configElements {
    [self.view addSubview:self.btnRecord];
    [self.view addSubview:self.collectionView];
    
    [self.view needsUpdateConstraints];
}

// 切换布局
- (void)changeCollectionViewLayout {
    __weak typeof(self)weakSelf = self;
    if ([self.collectionView.collectionViewLayout isEqual:self.gridFlowLayout]) {
        [self.collectionView setCollectionViewLayout:self.pageFlowLayout animated:YES completion:^(BOOL finished) {
            if (finished) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
//                [strongSelf.collectionView reloadData];
            }
        }];
        [self.layoutItem setImage:[UIImage imageNamed:@"me_photoGrid"]];
    } else {
        [self.collectionView setCollectionViewLayout:self.gridFlowLayout animated:YES completion:^(BOOL finished) {
            if (finished) {
                __strong typeof(weakSelf)strongSelf = weakSelf;
//                [strongSelf.collectionView reloadData];
            }
        }];
        [self.layoutItem setImage:[UIImage imageNamed:@"me_photoPage"]];
    }
}

// 记录今日体型
- (void)recordTodayBodilyForm {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"图库选择", nil];
    [sheet showInView:self.view];

}

// 设置头像
- (void)pickImageisFromCamera:(BOOL)isFromCamera
{
    NSInteger sourceType;
    // 拍照
    if (isFromCamera)
    {
        // 判断是否有摄像头
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else
        {
            [self postError:@"没有发现摄像头"];
            return;
        }
    }
    // 相册
    else
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController Dalegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:NO completion:^{
        // 改变状态栏的颜色  改变为白色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // TODO: 存数据库
    if (picker) {
        [self dismissViewControllerAnimated:NO completion:^{
            // 改变状态栏的颜色  改变为白色
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
    
}

#pragma mark - UIActSheet Dalegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self pickImageisFromCamera:NO];
    }
    else if(buttonIndex == 0)
    {
        [self pickImageisFromCamera:YES];
    }
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 21;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([collectionView.collectionViewLayout isEqual:self.gridFlowLayout]) {
        NSLog(@"-------------->grid");
        MeGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGridCell forIndexPath:indexPath];
        return cell;
//    } else {
//        MePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPageCell forIndexPath:indexPath];
//        NSLog(@"-------------->flow");
//
//        return cell;
//    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Init
- (UIButton *)btnRecord {
    if (!_btnRecord ) {
        _btnRecord = [[UIButton alloc] init];
        [_btnRecord setBackgroundImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [_btnRecord setTitle:@"记录今日的体型" forState:UIControlStateNormal];
        [_btnRecord setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnRecord.titleLabel setFont:[UIFont systemFontOfSize:fontSize_15]];
        [_btnRecord addTarget:self action:@selector(recordTodayBodilyForm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnRecord;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.gridFlowLayout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView registerClass:[MeGridCollectionViewCell class] forCellWithReuseIdentifier:kGridCell];
//        [_collectionView registerClass:[MePageCollectionViewCell class] forCellWithReuseIdentifier:kPageCell];

        [_collectionView setBackgroundColor:[UIColor colorLightBlack_2e2e2e]];
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)gridFlowLayout {
    if (!_gridFlowLayout) {
        _gridFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _gridFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width * 0.5 - 10,self.view.frame.size.width * 0.5 - 10);
        _gridFlowLayout.minimumLineSpacing = 5;
        _gridFlowLayout.minimumInteritemSpacing = 5;
        _gridFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        [_gridFlowLayout setSectionInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
    return _gridFlowLayout;
}

- (UICollectionViewFlowLayout *)pageFlowLayout {
    if (!_pageFlowLayout) {
        _pageFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _pageFlowLayout.itemSize = CGSizeMake(self.view.frame.size.width - 40,self.view.frame.size.height - 70);
        _pageFlowLayout.minimumLineSpacing = 15;
        _pageFlowLayout.minimumInteritemSpacing = 15;
        _pageFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [_pageFlowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
    }
    return _pageFlowLayout;

}

- (UIBarButtonItem *)layoutItem {
    if (!_layoutItem) {
        _layoutItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"me_photoPage"] style:UIBarButtonItemStylePlain target:self action:@selector(changeCollectionViewLayout)];
    }
    return _layoutItem;
}
@end

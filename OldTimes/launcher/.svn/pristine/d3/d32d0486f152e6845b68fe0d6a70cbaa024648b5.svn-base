//
//  MeShareViewController.m
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "MeShareViewController.h"
#import "MeShareCollectionViewCell.h"
#import "UIColor+Hex.h"
#import "MyDefine.h"

@interface MeShareViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *CollectionView;
@property (nonatomic, strong) NSMutableArray *arrImgs;
@end

@implementation MeShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCAL(ME_SHARE);
    [self setdata];
    self.view.backgroundColor = [UIColor grayBackground];
    [self.view addSubview:self.CollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setdata
{
    for (NSInteger i = 1; i<7; i++)
    {
        [self.arrImgs addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Me_share_%ld",(long)i]]];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MeShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeShareCollectionViewCellID" forIndexPath:indexPath];
    [cell.imgview setImage:[self.arrImgs objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(55,55);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(55, 40 , 55, 40);
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - init
- (UICollectionView *)CollectionView
{
    if (!_CollectionView)
    {
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
        flowLayout.minimumInteritemSpacing = (self.view.frame.size.width - 110 - 165)/2;
        flowLayout.minimumLineSpacing = 40;
        _CollectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 14, [UIScreen mainScreen].bounds.size.width, (self.arrImgs.count + 2)/3 * 100 + 65) collectionViewLayout:flowLayout];
        _CollectionView.allowsMultipleSelection = NO;
        _CollectionView.backgroundColor = [UIColor whiteColor];
        _CollectionView.scrollEnabled = NO;
        _CollectionView.delegate = self;
        _CollectionView.dataSource = self;
        [_CollectionView registerClass:[MeShareCollectionViewCell class]forCellWithReuseIdentifier:@"MeShareCollectionViewCellID"];
    }
    return _CollectionView;
}

- (NSMutableArray *)arrImgs
{
    if (!_arrImgs)
    {
        _arrImgs = [[NSMutableArray alloc] init];
    }
    return _arrImgs;
}
@end

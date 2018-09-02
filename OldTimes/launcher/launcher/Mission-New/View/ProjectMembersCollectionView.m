//
//  ProjectMembersCollectionView.m
//  launcher
//
//  Created by TabLiu on 16/2/19.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ProjectMembersCollectionView.h"
#import "MyDefine.h"
#import "ProjectMembersCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface ProjectMembersCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * collectionView ;
@property (nonatomic,strong) NSArray * dataArray;

@end

@implementation ProjectMembersCollectionView

- (void)setProjectMembersData:(NSArray *)array
{
    self.dataArray = array;
    NSInteger line = array.count%5 == 0?array.count/5:array.count/5+1;
    if (line >3)
    {
        line = 3;
    }
    self.frame = CGRectMake(0, 0, IOS_SCREEN_WIDTH, 100* line);
    self.collectionView.frame = self.frame;
    [self.collectionView reloadData];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc ]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        
        self.collectionView=[[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        
        //注册Cell
        [self.collectionView registerClass:[ProjectMembersCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        
        [self addSubview:self.collectionView];

        UIView * line = [[UIView alloc] init];
        line.userInteractionEnabled = YES;
        line.backgroundColor = [UIColor blackColor];
        [self addSubview:line];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProjectMembersCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    [cell setCellData:_dataArray[indexPath.row]];
    return cell;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int width = IOS_SCREEN_WIDTH/5;
    return CGSizeMake(width, 100);
}
//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end

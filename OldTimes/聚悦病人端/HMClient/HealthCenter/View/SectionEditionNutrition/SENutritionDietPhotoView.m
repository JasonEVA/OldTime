//
//  SENutritionDietPhotoView.m
//  HMClient
//
//  Created by lkl on 2017/8/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "SENutritionDietPhotoView.h"

#define PhotoHeight (kScreenWidth-70)/6

@interface SENutritionDietPhotoCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIButton* delBtn;

@end


@implementation SENutritionDietPhotoCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //[self.contentView setBackgroundColor:[UIColor orangeColor]];
        
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        self.imageView.userInteractionEnabled =YES;
        [self.imageView.layer setCornerRadius:4];
        [self.imageView.layer setMasksToBounds:YES];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(self.contentView.size.width, self.contentView.size.width));
        }];
        
        self.delBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.delBtn];
        [self.delBtn setImage:[UIImage imageNamed:@"icon_close2"] forState:UIControlStateNormal];
        
        [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}
@end

@interface SENutritionDietPhotoView () <UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation SENutritionDietPhotoView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview: self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.center.equalTo(self);
            make.height.mas_equalTo(PhotoHeight+20);
        }];
        
        [_collectionView addSubview:self.btnAddPhoto];
        [_btnAddPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_collectionView).offset(10);
            make.size.mas_equalTo(CGSizeMake(PhotoHeight, PhotoHeight));
        }];
        
        [_collectionView addSubview:self.promptLabel];
        [_promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_btnAddPhoto.mas_right).offset(10);
            make.top.equalTo(_collectionView).offset(10);
            make.centerY.equalTo(_btnAddPhoto);
        }];
    }
    return self;
}

#pragma mark -- Private Method

- (void)reloadPhotos:(NSArray *)photos
{
    [self.phonelist addObjectsFromArray:photos];
    [self resetLayout];
}

- (void)addPhotoBtn:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(hm_addImage)]) {
        [self.delegate hm_addImage];
    }
}

//删除照片的事件
- (void)btnDelPhone:(UIButton *)sender
{
    [self.phonelist removeObjectAtIndex:sender.tag - 100];
    [self resetLayout];

    if (self.delegate && [self.delegate respondsToSelector:@selector(hm_deleteImage:)]) {
        [self.delegate hm_deleteImage:sender.tag - 100];
    }
}

//删除照片
- (void)delAllPhotos
{
    [self.phonelist removeAllObjects];
    [self resetLayout];
}

-(void)resetLayout
{
    int columnCount = ceilf((_phonelist.count + 1) * 1.0 / 6);
    float height = columnCount * (PhotoHeight +10)+10;
    if (height < PhotoHeight+20) {
        height = PhotoHeight+20;
    }
    CGRect rect = _collectionView.frame;
    rect.size.height = height;
    _collectionView.frame = rect;
    [_collectionView reloadData];
    
    [_promptLabel setHidden:_phonelist.count >= 2 ? 1 : 0];
    [_btnAddPhoto setHidden:_phonelist.count >= 5 ? 1 : 0];
    
    [_btnAddPhoto mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10+(10+PhotoHeight)*(self.phonelist.count%6));
        make.top.mas_equalTo(_collectionView.height-PhotoHeight-10);
        make.size.mas_equalTo(CGSizeMake(PhotoHeight, PhotoHeight));
    }];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.phonelist.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SENutritionDietPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SENutritionDietPhotoCell" forIndexPath:indexPath];
    //cell.imageView.image = [self.phonelist objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.phonelist[indexPath.row]] placeholderImage:[UIImage imageNamed:@"image_placeholder_loading"]];
    cell.delBtn.tag = 100+indexPath.row;
    [cell.delBtn addTarget:self action:@selector(btnDelPhone:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(PhotoHeight, PhotoHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


#pragma mark -- init
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[SENutritionDietPhotoCell class] forCellWithReuseIdentifier:@"SENutritionDietPhotoCell"];
    }
    return _collectionView;
}

- (UIButton *)btnAddPhoto{
    if (!_btnAddPhoto) {
        _btnAddPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAddPhoto setBackgroundImage:[UIImage imageNamed:@"append_image"] forState:UIControlStateNormal];
        [_btnAddPhoto addTarget:self action:@selector(addPhotoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnAddPhoto;
}

- (UILabel *)promptLabel{
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        [_promptLabel setText:@"添加饮食照片(最多5张)"];
        [_promptLabel setTextColor:[UIColor commonGrayTextColor]];
        [_promptLabel setFont:[UIFont font_26]];
    }
    return _promptLabel;
}

- (NSMutableArray *)phonelist{
    if (!_phonelist) {
        _phonelist = [[NSMutableArray alloc] init];
    }
    return _phonelist;
}
@end

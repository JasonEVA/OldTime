//
//  BloodSugarEditDietView.m
//  HMClient
//
//  Created by lkl on 2017/7/7.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodSugarEditDietView.h"


#define PhotoHeight (kScreenWidth-60-25)/5

@interface QTRejectViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIButton* delBtn;

@end


@implementation QTRejectViewCell

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


@interface BloodSugarEditDietView ()<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *promptLabel;

@end

@implementation BloodSugarEditDietView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview: self.collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
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
        
        _tvSymptom = [[PlaceholderTextView alloc]init];
        _tvSymptom.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _tvSymptom.layer.borderWidth = 0.5;
        [_tvSymptom setFont:[UIFont font_28]];
        _tv = (PlaceholderTextView*) _tvSymptom;
        [_tv setPlaceholder:@"请描述您的相关情况，如饮食等"];
        [self addSubview:_tvSymptom];

        [_tvSymptom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_collectionView.mas_bottom);
            make.height.mas_equalTo(@93);
            make.left.equalTo(self).with.offset(12.5);
            make.right.equalTo(self).with.offset(-12.5);
        }];
    }
    return self;
}

- (void)isHasPhotosOrDiet:(BOOL)isHas
{
    if (isHas) {
        [self addSubview:self.deleteButton];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tvSymptom.mas_bottom).with.offset(31);
            make.height.mas_equalTo(@42);
            make.left.equalTo(self).with.offset(12.5);
            make.width.mas_equalTo(115 * kScreenScale);
        }];
        
        [self addSubview:self.commitButton];
        [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tvSymptom.mas_bottom).with.offset(31);
            make.height.mas_equalTo(@42);
            make.right.equalTo(self).with.offset(-12.5);
            make.width.equalTo(_deleteButton.mas_width);
        }];
    }
    else{
        [self addSubview:self.commitButton];
        [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tvSymptom.mas_bottom).with.offset(31);
            make.height.mas_equalTo(@46);
            make.left.equalTo(self).with.offset(12.5);
            make.right.equalTo(self).with.offset(-12.5);
        }];
    }
}

-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    UIImage *result;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

- (void)reloadPhotos:(NSArray *)photos
{
//    [photos enumerateObjectsUsingBlock:^(NSString *picUrl, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.phonelist addObject:[self getImageFromURL:picUrl]];
//    }];
    [self.phonelist addObjectsFromArray:photos];
    [self resetLayout];
}

#pragma mark -- Private Method

//删除照片的事件
- (void)btnDelPhone:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"detelePhontNotification" object:[NSString stringWithFormat:@"%ld",sender.tag - 100]];
    [self.phonelist removeObjectAtIndex:sender.tag - 100];
    [self resetLayout];
}

//删除照片
- (void)delClick
{
    [self.phonelist removeAllObjects];
    [self resetLayout];
}

-(void)resetLayout
{
    int columnCount = ceilf((_phonelist.count + 1) * 1.0 / 5);
    float height = columnCount * (PhotoHeight +10)+10;
    if (height < PhotoHeight+20) {
        height = PhotoHeight+20;
    }
    CGRect rect = _collectionView.frame;
    rect.size.height = height;
    _collectionView.frame = rect;
    [_collectionView reloadData];
    
    //
    if (_phonelist.count >= 2) {
        [_promptLabel setHidden:YES];
    }
    else{
        [_promptLabel setHidden:NO];
    }
    
    if (_phonelist.count >= 5) {
        [_btnAddPhoto setHidden:YES];
    }
    else{
        [_btnAddPhoto setHidden:NO];
    }
    
    [_btnAddPhoto mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10+(10+PhotoHeight)*(self.phonelist.count%5));
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
    QTRejectViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"rejectViewMeCell" forIndexPath:indexPath];
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
        [_collectionView registerClass:[QTRejectViewCell class] forCellWithReuseIdentifier:@"rejectViewMeCell"];
    }
    return _collectionView;
}

- (UIButton *)btnAddPhoto{
    if (!_btnAddPhoto) {
        _btnAddPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnAddPhoto setBackgroundImage:[UIImage imageNamed:@"append_image"] forState:UIControlStateNormal];
    }
    return _btnAddPhoto;
}

- (UIButton *)commitButton{
    if (!_commitButton)
    {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _commitButton.layer.cornerRadius = 2.5;
        _commitButton.layer.masksToBounds = YES;
        [_commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 46) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setTitle:@"保存" forState:UIControlStateNormal];
        [_commitButton.titleLabel setFont:[UIFont font_32]];
    }
    return _commitButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.layer.cornerRadius = 2.5;
        _deleteButton.layer.masksToBounds = YES;
        [_deleteButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 46) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton.titleLabel setFont:[UIFont font_32]];
    }
    return _deleteButton;
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

//
//  BloodSugarResultSymptomView.m
//  HMClient
//
//  Created by yinqaun on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodSugarResultSymptomView.h"
#import "ImageCutViewController.h"

#import "PlaceholderTextView.h"


@implementation BloodSugarResultSymptomImageControl

- (id) init
{
    self = [super init];
    if (self)
    {
        ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"append_image"]];
        [self addSubview:ivBackground];
       
        ivImage = [[UIImageView alloc]init];
        [self addSubview:ivImage];
        //[self setBackgroundColor:[UIColor redColor]];
        [self addTarget:self action:@selector(imageControlClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [ivBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self).with.offset(7.5);
        make.right.and.bottom.equalTo(self).with.offset(-7.5);
        make.center.equalTo(self);
    }];
    
    
    [ivImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.center.equalTo(self);
    }];
}

- (void) setImage:(UIImage*) image
{
    _image = image;
    [ivImage setImage:image];
}

- (void) setimageUrl:(NSString *)imgUrl
{
    _imgUrl = imgUrl;
}

- (void) imageControlClicked:(id) sender
{
    if (_clickBlock)
    {
        _clickBlock(self);
    }
}

@end

@interface BloodSugarResultSymptomImageListView : UIView
{
    NSMutableArray* imageList;
    NSMutableArray* imageUrlList;
    UILabel* remindLb;

}
@property (nonatomic,retain) NSMutableArray* imageControls;
@property (nonatomic, strong) BloodSugarImageControlBlock imgclickBlock;

- (id) initWithImageControlBlock:(BloodSugarImageControlBlock) clickblock;

- (void) imageListChanged;
@end

@implementation BloodSugarResultSymptomImageListView

- (id) initWithImageControlBlock:(BloodSugarImageControlBlock) clickblock
{
    self = [super init];
    if (self)
    {
        _imgclickBlock = clickblock;
        imageList = [NSMutableArray array];
        imageUrlList = [NSMutableArray array];
        [self createImageControls];
    }
    return self;
}

- (void) createImageControls
{
    if (_imageControls)
    {
        for (BloodSugarResultSymptomImageControl* imgControl in _imageControls) {
            [imgControl removeFromSuperview];
        }
        
        [_imageControls removeAllObjects];
    }
    _imageControls = [NSMutableArray array];
    
    for (NSInteger index = 0; index < imageList.count; ++index)
    {
        BloodSugarResultSymptomImageControl* imgControl = [[BloodSugarResultSymptomImageControl alloc]init];
        [self addSubview:imgControl];
        [_imageControls addObject:imgControl];
    
        [imgControl setImage:[imageList objectAtIndex:index]];
        [imgControl setImgUrl:[imageUrlList objectAtIndex:index]];
        [imgControl setClickBlock:_imgclickBlock];
        
        UIButton *deleteBtn = [[UIButton alloc] init];
        [imgControl addSubview:deleteBtn];
        [deleteBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [deleteBtn setTag:index];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.top.equalTo(imgControl);
            make.left.equalTo(imgControl.mas_right).with.offset(-15);
        }];
    }
    
    
    if (_imageControls.count < 5)
    {
        BloodSugarResultSymptomImageControl* imgControl = [[BloodSugarResultSymptomImageControl alloc]init];
        [self addSubview:imgControl];
        [_imageControls addObject:imgControl];
        [imgControl setClickBlock:_imgclickBlock];
        
        if (_imageControls.count < 2) {
            remindLb = [[UILabel alloc] init];
            [remindLb setTextColor:[UIColor colorWithHexString:@"999999"]];
            [remindLb setText:@"添加饮食照片(最多5张)"];
            [imgControl addSubview:remindLb];
            [remindLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(imgControl.mas_right).offset(5);
                make.centerY.equalTo(imgControl);
                make.right.lessThanOrEqualTo(self).offset(-5);
            }];

        }
        else {
            [remindLb setHidden:YES];
            [remindLb removeFromSuperview];
        }
        
    }
    [self subviewlayout];
}

- (void)deleteBtnClick:(UIButton *)sender
{
    [[_imageControls objectAtIndex:sender.tag] removeFromSuperview];
    [_imageControls removeObjectAtIndex:sender.tag];
    [self imageListChanged];

}

- (void) subviewlayout
{
    BloodSugarResultSymptomImageControl* imgControl = [_imageControls firstObject];
    [imgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(47, 47));
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    for (NSInteger index = 1; index < _imageControls.count; ++index)
    {
        BloodSugarResultSymptomImageControl* perControl = _imageControls[index - 1];
        BloodSugarResultSymptomImageControl* curControl = _imageControls[index];
        
        [curControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(47, 47));
            make.left.equalTo(perControl.mas_right).with.offset(8);
            make.centerY.equalTo(self);
        }];
    }
}

- (void) imageListChanged
{
    imageList = [NSMutableArray array];
    imageUrlList = [NSMutableArray array];
    for (NSInteger index = 0; index < _imageControls.count; ++index)
    {
        BloodSugarResultSymptomImageControl* curControl = _imageControls[index];
        if (curControl.image && curControl.imgUrl)
        {
            [imageList addObject:curControl.image];
            [imageUrlList addObject:curControl.imgUrl];
        }
    }
    
    [self createImageControls];
}



@end

@interface BloodSugarResultSymptomView ()
{
    BloodSugarResultSymptomImageListView* imageListView;
}


@end

@implementation BloodSugarResultSymptomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithImageControlBlock:(BloodSugarImageControlBlock) clickblock
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        imageListView = [[BloodSugarResultSymptomImageListView alloc]initWithImageControlBlock:(clickblock)];
        [self addSubview:imageListView];
        
        _tvSymptom = [[PlaceholderTextView alloc]init];
        _tvSymptom.layer.borderColor = [UIColor commonControlBorderColor].CGColor;
        _tvSymptom.layer.borderWidth = 0.5;
        [_tvSymptom setFont:[UIFont font_28]];
        _tv = (PlaceholderTextView*) _tvSymptom;
        [_tv setPlaceholder:@"请描述您的相关情况，如饮食等"];
        [self addSubview:_tvSymptom];
        
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_commitButton];
        _commitButton.layer.cornerRadius = 2.5;
        _commitButton.layer.masksToBounds = YES;
        [_commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 46) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_commitButton setTitle:@"保存" forState:UIControlStateNormal];
        [_commitButton.titleLabel setFont:[UIFont font_32]];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [imageListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(@59);
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
    }];
    
    [_tvSymptom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageListView.mas_bottom);
        make.height.mas_equalTo(@93);
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
    }];
    
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tvSymptom.mas_bottom).with.offset(31);
        make.height.mas_equalTo(@46);
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
    }];
}

- (void) imageListChanged
{
    [imageListView imageListChanged];
    self.imageControls = imageListView.imageControls;
}

@end

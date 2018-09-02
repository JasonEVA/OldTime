//
//  AppointmentImageList.m
//  HMClient
//
//  Created by lkl on 16/5/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AppointmentImageList.h"

@implementation AppointmentImageClickControl

- (id) init
{
    self = [super init];
    if (self)
    {
        ivBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_add"]];
        [self addSubview:ivBackground];
        
        ivImage = [[UIImageView alloc]init];
        [self addSubview:ivImage];
        
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

@interface AppointmentImageList : UIView
{
    NSMutableArray* imageList;
    NSMutableArray* imageUrlList;
    
}
@property (nonatomic,retain) NSMutableArray* imageControls;
@property (nonatomic, strong) AppointmentImageControlBlock imgclickBlock;

- (id) initWithImageControlBlock:(AppointmentImageControlBlock) clickblock;

- (void) imageListChanged;
@end

@implementation AppointmentImageList

- (id) initWithImageControlBlock:(AppointmentImageControlBlock) clickblock
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
        for (AppointmentImageClickControl* imgControl in _imageControls) {
            [imgControl removeFromSuperview];
        }
        
        [_imageControls removeAllObjects];
    }
    _imageControls = [NSMutableArray array];
    
    for (NSInteger index = 0; index < imageList.count; ++index)
    {
        AppointmentImageClickControl* imgControl = [[AppointmentImageClickControl alloc]init];
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
        AppointmentImageClickControl* imgControl = [[AppointmentImageClickControl alloc]init];
        [self addSubview:imgControl];
        [_imageControls addObject:imgControl];
        [imgControl setClickBlock:_imgclickBlock];
        
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
    AppointmentImageClickControl* imgControl = [_imageControls firstObject];
    [imgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(47, 47));
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    
    for (NSInteger index = 1; index < _imageControls.count; ++index)
    {
        AppointmentImageClickControl* perControl = _imageControls[index - 1];
        AppointmentImageClickControl* curControl = _imageControls[index];
        
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
        AppointmentImageClickControl* curControl = _imageControls[index];
        if (curControl.image && curControl.imgUrl)
        {
            [imageList addObject:curControl.image];
            [imageUrlList addObject:curControl.imgUrl];
        }
    }
    
    [self createImageControls];
}



@end

@interface AppointmentImageListView ()
{
    AppointmentImageList* imageListView;
}


@end

@implementation AppointmentImageListView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (id) initWithImageControlBlock:(AppointmentImageControlBlock) clickblock
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        imageListView = [[AppointmentImageList alloc]initWithImageControlBlock:(clickblock)];
        [self addSubview:imageListView];
        
        [self subviewLayout];
    }
    return self;
}

- (void) subviewLayout
{
    [imageListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(@50);
        make.left.equalTo(self);
        make.right.equalTo(self).with.offset(-12.5);
    }];
    
}

- (void) imageListChanged
{
    [imageListView imageListChanged];
     self.imageControls = imageListView.imageControls;
}

@end




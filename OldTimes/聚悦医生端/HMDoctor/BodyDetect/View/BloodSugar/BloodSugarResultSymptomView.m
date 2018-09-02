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
    NSMutableArray* imageControls;
}
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
        [self createImageControls];
    }
    return self;
}

- (void) createImageControls
{
    if (imageControls)
    {
        for (BloodSugarResultSymptomImageControl* imgControl in imageControls) {
            [imgControl removeFromSuperview];
        }
        
        [imageControls removeAllObjects];
    }
    imageControls = [NSMutableArray array];
    
    for (NSInteger index = 0; index < imageList.count; ++index)
    {
        BloodSugarResultSymptomImageControl* imgControl = [[BloodSugarResultSymptomImageControl alloc]init];
        [self addSubview:imgControl];
        [imageControls addObject:imgControl];
        [imgControl setImage:[imageList objectAtIndex:index]];
        [imgControl setClickBlock:_imgclickBlock];
        
    }
    
    if (imageControls.count < 4)
    {
        BloodSugarResultSymptomImageControl* imgControl = [[BloodSugarResultSymptomImageControl alloc]init];
        [self addSubview:imgControl];
        [imageControls addObject:imgControl];
        [imgControl setClickBlock:_imgclickBlock];
        
    }
    
    [self subviewlayout];
}

- (void) subviewlayout
{
    BloodSugarResultSymptomImageControl* imgControl = [imageControls firstObject];
    [imgControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(47, 47));
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    for (NSInteger index = 1; index < imageControls.count; ++index)
    {
        BloodSugarResultSymptomImageControl* perControl = imageControls[index - 1];
        BloodSugarResultSymptomImageControl* curControl = imageControls[index];
        
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
    for (NSInteger index = 0; index < imageControls.count; ++index)
    {
        BloodSugarResultSymptomImageControl* curControl = imageControls[index];
        if (curControl.image)
        {
            [imageList addObject:curControl.image];
        }
    }
    
    [self createImageControls];
}



@end

@interface BloodSugarResultSymptomView ()
{
    BloodSugarResultSymptomImageListView* imageListView;
    
    UIButton* commitButton;
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
        [_tvSymptom setFont:[UIFont systemFontOfSize:14]];
        PlaceholderTextView* tv = (PlaceholderTextView*) _tvSymptom;
        [tv setPlaceholder:@"请描述您的相关情况，如饮食等"];
        [self addSubview:_tvSymptom];
        
        commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:commitButton];
        commitButton.layer.cornerRadius = 2.5;
        commitButton.layer.masksToBounds = YES;
        [commitButton setBackgroundImage:[UIImage rectImage:CGSizeMake(320, 46) Color:[UIColor mainThemeColor]] forState:UIControlStateNormal];
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commitButton setTitle:@"提交" forState:UIControlStateNormal];
        [commitButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
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
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tvSymptom.mas_bottom).with.offset(31);
        make.height.mas_equalTo(@46);
        make.left.equalTo(self).with.offset(12.5);
        make.right.equalTo(self).with.offset(-12.5);
    }];
}

- (void) imageListChanged
{
    [imageListView imageListChanged];
}
@end

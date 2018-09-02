//
//  BloodSugarAddDietView.m
//  HMClient
//
//  Created by lkl on 2017/7/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BloodSugarAddDietView.h"

@interface BloodSugarAddDietView ()

@end

@implementation BloodSugarAddDietView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.6]];
        UIControl* closeControl = [[UIControl alloc] initWithFrame:self.bounds];
        [self addSubview:closeControl];
        [closeControl setBackgroundColor:[UIColor orangeColor]];
        [closeControl addTarget:self action:@selector(closeControlClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void) closeControlClicked
{
    [self removeFromSuperview];
}

@end

/*****添加饮食情况********/
@interface BloodSugarAddDietControl ()

@property (nonatomic, strong) UIImageView *addImgView;
@property (nonatomic, strong) UILabel *addDietLabel;
@property (nonatomic, strong) UIImageView *icon;

@end

@implementation BloodSugarAddDietControl

- (id)init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _addImgView = [[UIImageView alloc] init];
        [self addSubview:_addImgView];
        [_addImgView setImage:[UIImage imageNamed:@"icon_add"]];
        [_addImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@12.5);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        _addDietLabel = [UILabel new];
        [self addSubview:_addDietLabel];
        [_addDietLabel setTextColor:[UIColor commonTextColor]];
        [_addDietLabel setFont:[UIFont font_30]];
        [_addDietLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_addImgView.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
        
        _icon = [[UIImageView alloc] init];
        [_icon setImage:[UIImage imageNamed:@"icon_x_arrows"]];
        [self addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).with.offset(-12);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(10, 15));
        }];
    }
    return self;
}

- (void)isHasDietResult:(BOOL)isResult
{
    if (isResult) {
        [_addImgView setHidden:YES];
        [_addDietLabel setText:@"饮食情况"];
        [_addDietLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12.5);
            make.centerY.equalTo(self);
        }];
    }
    else{
        [_addImgView setHidden:NO];
        [_addDietLabel setText:@"添加饮食情况"];
        [_addDietLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_addImgView.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
    }
}


@end


/************饮食情况结果**************/
@interface BloodSugarDietResultView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *dietLabel;
@property (nonatomic, copy) NSMutableArray *picArray;
@end

@implementation BloodSugarDietResultView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        if (!_picArray) {
            _picArray = [[NSMutableArray alloc] init];
        }
        for (int i = 0; i < 5; i++)
        {
            _imgView = [[UIImageView alloc] init];
            [self addSubview:_imgView];
            _imgView.tag = i;
            [_picArray addObject:_imgView];
            [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(12.5+i*(47+5));
                make.top.mas_equalTo(10);
                make.size.mas_equalTo(CGSizeMake(47, 47));
            }];
        }
        
        _dietLabel = [[UILabel alloc] init];
        [self addSubview:_dietLabel];
        [_dietLabel setNumberOfLines:0];
        [_dietLabel setTextColor:[UIColor commonGrayTextColor]];
        [_dietLabel setFont:[UIFont font_28]];
    }
    
    return self;
}


- (void)setBloodSugarDetectResult:(BloodSugarDetectResult *)result
{
    [_picArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_imgView setImage:[UIImage imageNamed:@""]];
    }];
    
    [result.dataDets.XT_IMGS enumerateObjectsUsingBlock:^(NSString *picUrl, NSUInteger idx, BOOL * _Nonnull stop) {
        _imgView = [_picArray objectAtIndex:idx];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:[result.dataDets.XT_IMGS objectAtIndex:idx]]];
    }];

    [_dietLabel setText:result.diet];
    [_dietLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12.5);
        make.right.equalTo(self).with.offset(-12.5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-10);
    }];
}


@end

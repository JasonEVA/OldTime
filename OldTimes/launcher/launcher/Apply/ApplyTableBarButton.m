//
//  ApplyButton.m
//  launcher
//
//  Created by Kyle He on 15/8/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  

#import "ApplyTableBarButton.h"
#import "MyDefine.h"
#import "Masonry.h"
#import "Category.h"
#import "RoundCountView.h"

@interface ApplyButton ()
@property (nonatomic , strong) UIImageView  *iconView;
@property (nonatomic , strong) UILabel  *titlelb;
@property (nonatomic , strong) RoundCountView *roundView;
@property (nonatomic , strong) UIImage  *selectedImg;
@end

@implementation ApplyButton

-(instancetype)init
{
    if (self = [super init])
    {
        [self createFrame];
    }
    return self;
    
}
#pragma mark - 实现选中状态的文字状态和角标设置
//改变选中状态的同时设置不同状态的图片
-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;

    self.titlelb.textColor  = isSelected ? [UIColor themeBlue]:[UIColor blackColor];
    self.iconView.image = isSelected ? self.item.selectedImage:self.item.image;
}

//将自带的item作为模型传入
-(void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    self.roundView.hidden = YES;
    self.iconView.image =self.item.image;
    self.titlelb.text = self.item.title;
    self.selectedImg = self.item.selectedImage;
    
    
    //给传入的item添加监听，一旦值改变，同时改变
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([self.item.badgeValue integerValue])
    {
        [self.roundView setCount:[self.item.badgeValue intValue]];
         self.roundView.hidden = NO;
    }else
    {
        self.roundView.hidden = YES;
    }
}

#pragma mark - initilizer
-(RoundCountView *)roundView
{
    if (!_roundView)
    {
        _roundView = [[RoundCountView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        self.roundView.lblTitle.font = [UIFont systemFontOfSize:8];
    }
    return _roundView;
}

- (UILabel *)titlelb {
    if (!_titlelb) {
        _titlelb = [[UILabel alloc]init];
        _titlelb.font = [UIFont mtc_font_30];
    }
    return _titlelb;
}

-(UIImageView *)iconView
{
    if (!_iconView)
    {
        _iconView = [[UIImageView alloc]init];
        
    }
    return _iconView;
}

#pragma mark - crateFarme
-(void)createFrame
{
    [self addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(-24);

    }];
    [self addSubview:self.titlelb];
    [self.titlelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self).offset(19);
    }];
    [self addSubview:self.roundView];
    [self.roundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titlelb.mas_right).offset(12);
        make.top.equalTo(self.titlelb).offset(-3);
        make.width.equalTo(@(15));
        make.height.equalTo(@(15));
    }];
}

-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
}
@end

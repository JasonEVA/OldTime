//
//  NewCalendarMouthADayCollectionViewCell.m
//  launcher
//
//  Created by kylehe on 16/3/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
// 月中每日的cell


#import "NewCalendarMonthADayCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIImage+Manager.h"
@interface NewCalendarMonthADayCollectionViewCell ()

@property(nonatomic, strong) UIButton  *numberBtn;

@end

@implementation NewCalendarMonthADayCollectionViewCell

+ (NSString *)identifier
{
    return NSStringFromClass([self class]);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createFrame];
    }
    return self;
}

#pragma mark - interfaceMethod
- (void)setNumberWithNum:(NSNumber *)number
{
    [self setNumberWithNum:number isSeleted:NO];
}

- (void)setNumberWithNum:(NSNumber *)number isSeleted:(BOOL)isSeleted
{
    [self.numberBtn setTitle:[NSString stringWithFormat:@"%@",number] forState:UIControlStateNormal];
    
    self.numberBtn.selected = isSeleted;
}

#pragma mark - privateMethod
- (void)createFrame
{
    [self.contentView addSubview:self.numberBtn];
    [self.numberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.equalTo(@20);
    }];
}

#pragma mark - setterAndGetter

- (UIButton *)numberBtn
{
    if (!_numberBtn)
    {
        _numberBtn = [[UIButton alloc] init];
        [_numberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _numberBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_numberBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_numberBtn setBackgroundImage:[UIImage mtc_imageColor:[UIColor colorWithRed:0.18 green:0.62 blue:0.98 alpha:1]] forState:UIControlStateSelected];
    }
    return _numberBtn;
}

@end

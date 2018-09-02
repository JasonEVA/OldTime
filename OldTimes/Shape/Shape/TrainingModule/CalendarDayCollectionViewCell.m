//
//  CalendarDayCollectionViewCell.m
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "CalendarDayCollectionViewCell.h"
#import "UIColor+Hex.h"

@interface CalendarDayCollectionViewCell()
@property (nonatomic, strong)  UIButton  *btn; // <##>

@end
@implementation CalendarDayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.btn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [self.btn setSelected:selected];
}

- (void)setTitleDay:(NSString *)day {
    [self.btn setTitle:day forState:UIControlStateNormal];
}

-  (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] init];
        [_btn setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [_btn setBackgroundImage:[UIColor switchToImageWithColor:[UIColor themeOrange_ff5d2b] size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [_btn setTitleColor:[UIColor colorDarkGray_737272] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btn.layer setCornerRadius:self.frame.size.height * 0.5];
        [_btn.layer setMasksToBounds:YES];
        [_btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_btn setUserInteractionEnabled:NO];
    }
    return _btn;
}

@end

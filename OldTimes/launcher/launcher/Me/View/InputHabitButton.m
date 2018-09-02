//
//  InputHabitButton.m
//  launcher
//
//  Created by williamzhang on 15/12/2.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "InputHabitButton.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface InputHabitButton()

@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation InputHabitButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.imageView];
        [self addSubview:self.roundView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.selectedImageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(15);
        }];
        
        [self.roundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(13);
            make.centerX.equalTo(self).offset(-15);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.roundView);
            make.left.equalTo(self.roundView.mas_right).offset(8);
        }];
        
        [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Interface Method
- (void)setSelected:(BOOL)selected {
    self.selectedImageView.hidden = !selected;
}

#pragma mark - Initializer
@synthesize imageView, roundView, titleLabel;
- (UIImageView *)imageView {
    if (!imageView) {
        imageView = [UIImageView new];
    }
    return imageView;
}

- (UIImageView *)roundView {
    if (!roundView) {
        roundView = [UIImageView new];
        [roundView setImage:[[UIImage mtc_imageColor:roundView.tintColor size:CGSizeMake(10, 10) cornerRadius:5] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate
                             ]];
    }
    return roundView;
}

- (UILabel *)titleLabel {
    if (!titleLabel) {
        titleLabel = [UILabel new];
        titleLabel.font = [UIFont mtc_font_26];
    }
    return titleLabel;
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Me_Input_Select"]];
        _selectedImageView.hidden = 0;
    }
    return _selectedImageView;
}

@end

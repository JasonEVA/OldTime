//
//  CalendarButtonsTableViewCell.m
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "CalendarButtonsTableViewCell.h"
#import <Masonry/Masonry.h>
#import "Category.h"

@interface CalendarButtonsTableViewCell ()

@property (nonatomic, copy) void (^clickedButton)(NSInteger index);

@end

@implementation CalendarButtonsTableViewCell

+ (NSString *)identifier { return NSStringFromClass(self);}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *editButton   = [self createButtonImage:@"pencil" tag:0];
        UIButton *deleteButton = [self createButtonImage:@"calendar_big_trash" tag:1];
        
        [self.contentView addSubview:editButton];
        [self.contentView addSubview:deleteButton];
        
        [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.top.equalTo(self.contentView);
        }];
        [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(self.contentView);
            make.width.equalTo(editButton);
            make.left.equalTo(editButton.mas_right);
        }];
        
        UIView *seperatorLine = [UIView new];
        seperatorLine.backgroundColor = [UIColor borderColor];

        [self.contentView addSubview:seperatorLine];
        [seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0.5);
            make.bottom.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView).dividedBy(2);
        }];
    }
    return self;
}

- (void)clickedButton:(void (^)(NSInteger))clickAtIndexBlock {
    _clickedButton = clickAtIndexBlock;
}

#pragma mark - Button Click
- (void)clickToAction:(UIButton *)button {
    !self.clickedButton ?: self.clickedButton(button.tag);
}

#pragma mark - Creater
- (UIButton *)createButtonImage:(NSString *)imageName tag:(NSInteger)tag {
    UIButton *button = [UIButton new];
    [button setTintColor:[UIColor themeBlue]];
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    [button setImage:image forState:UIControlStateNormal];
    
    [button setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[UIImage mtc_imageColor:[UIColor buttonHighlightColor]] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(clickToAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    
    return button;
}

@end

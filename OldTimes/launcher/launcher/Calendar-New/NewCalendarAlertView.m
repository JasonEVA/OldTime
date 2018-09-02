//
//  NewCalendarAlertView.m
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "NewCalendarAlertView.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface NewCalendarAlertView ()

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) UIButton *selectedButton;

@property (nonatomic, strong) UIControl * control;
@property (nonatomic, strong) UILabel * nameLabel ;
@property (nonatomic, strong) UILabel * backLabel;

@end

@implementation NewCalendarAlertView

- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles {
    NSAssert(images.count == titles.count, @"错误❌");
    self = [super init];
    if (self) {
        {
            UIView *lastView;
            for (NSInteger i = 0; i < [images count]; i ++) {
                UIImage *image = [images objectAtIndex:i];
                NSString *title = [titles objectAtIndex:i];
                
                UIButton *button = [self buttonTitle:title image:image];
                button.tag = i;
                [self addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self);
                    if (lastView) {
                        make.left.equalTo(lastView.mas_right);
                        make.width.equalTo(lastView);
                    } else {
                        make.left.equalTo(self);
                    }
                    
                    if (i == [images count] - 1) {
                        make.right.equalTo(self);
                    }
                }];
                
                lastView = button;
                [self.buttonArray addObject:button];
            }
            ((UIButton *)[self.buttonArray lastObject]).selected = YES;
            
        }
        
        UIView *topSeperatorLine = [UIView new];
        topSeperatorLine.backgroundColor = [UIColor borderColor];
        [self addSubview:topSeperatorLine];
        
        [topSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}


- (instancetype)initWithImages:(NSArray *)images selectImages:(NSArray *)selectImages titles:(NSArray *)titles
{
    self = [super init];
    if (self) {
        {
            UIView *lastView;
            for (NSInteger i = 0; i < [images count]; i ++) {
                UIImage *image = [images objectAtIndex:i];
                NSString *title = [titles objectAtIndex:i];
                UIImage *selectImg = [selectImages objectAtIndex:i];
                
                UIButton *button = [self buttonTitle:title image:image selectImg:selectImg];
                button.tag = i;
                [self addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self);
                    if (lastView) {
                        make.left.equalTo(lastView.mas_right);
                        make.width.equalTo(lastView);
                    } else {
                        make.left.equalTo(self);
                    }
                    
                    if (i == [images count] - 1) {
                        make.right.equalTo(self);
                    }
                }];
                
                lastView = button;
                [self.buttonArray addObject:button];
            }
            
        }
        
        UIView *topSeperatorLine = [UIView new];
        topSeperatorLine.backgroundColor = [UIColor borderColor];
        [self addSubview:topSeperatorLine];
        
        [topSeperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return self;
}


#pragma mark - Interface Method
- (void)setSelectedIndex:(NSUInteger)index {
    
    self.selectedButton.selected = NO;
    @try {
        self.selectedButton = [self.buttonArray objectAtIndex:index];
        self.selectedButton.selected = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
}

- (void)setToday:(BOOL)isToday
{
    UIButton *btn = [self.buttonArray objectAtIndex:2];
    btn.selected = isToday;
}

- (void)lookOthersScheduleWithName:(NSString *)name
{
    UIView *lastView;
    float width = IOS_SCREEN_WIDTH/(self.buttonArray.count +1);
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = [self.buttonArray objectAtIndex:i];
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            }else {
                make.left.equalTo(self);
            }
            make.width.equalTo(@(width));
        }];
        lastView = btn;
    }
    [self creatOtherBtn];
    _nameLabel.text = name;
}

- (void)otherBtnClick
{
    UIView *lastView;
    float width = IOS_SCREEN_WIDTH/(self.buttonArray.count);
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *btn = [self.buttonArray objectAtIndex:i];
        [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            }else {
                make.left.equalTo(self);
            }
            make.width.equalTo(@(width));
        }];
        lastView = btn;
    }
    [self.control setHidden:YES];
    
    if ([self.delegate respondsToSelector:@selector(newCalendarAlertView:didClickedAtIndex:)]) {
        [self.delegate newCalendarAlertView:self didClickedAtIndex:3];
    }
    
}

- (void)creatOtherBtn
{
    if (!_control) {
        _control = [[UIControl alloc] init];
        _control.backgroundColor = [UIColor clearColor];
        [_control addTarget:self action:@selector(otherBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _control.layer.borderColor = [UIColor mtc_colorWithW:194].CGColor;
        _control.layer.borderWidth = 0.5;
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont mtc_font_22];
        _nameLabel.textColor = [UIColor colorWithRed:143/255.0 green:143/255.0 blue:143/255.0 alpha:1];
        [_control addSubview:_nameLabel];
        
        _backLabel = [[UILabel alloc] init];
        _backLabel.textAlignment = NSTextAlignmentCenter;
        _backLabel.textColor = [UIColor blackColor];
        _backLabel.font = [UIFont mtc_font_22];
        _backLabel.text = LOCAL(NEWCALENDAR_BACKTOMYEVENT);
        [_control addSubview:_backLabel];
        [self addSubview:_control];
        
        float width = IOS_SCREEN_WIDTH/(self.buttonArray.count +1);
        
        [_control mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.equalTo(@(width));
        }];
        [_nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_control.mas_left).offset(5);
            make.right.equalTo(_control.mas_right).offset(-5);
            make.top.equalTo(_control.mas_top).offset(10);
        }];
        [_backLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_control.mas_left).offset(5);
            make.right.equalTo(_control.mas_right).offset(-5);
            make.top.equalTo(_nameLabel.mas_bottom).offset(3);
        }];
        
	} else {
		_control.hidden = NO;
	}
	
}



#pragma mark - Button Click
- (void)clickedAtButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(newCalendarAlertView:didClickedAtIndex:)]) {
        [self.delegate newCalendarAlertView:self didClickedAtIndex:sender.tag];
    }
}

#pragma mark - Create
- (UIButton *)buttonTitle:(NSString *)title image:(UIImage *)image {
    UIButton *button = [UIButton new];
    
    button.layer.borderColor = [UIColor mtc_colorWithW:194].CGColor;
    button.layer.borderWidth = 0.5;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    
    [button.titleLabel setFont:[UIFont mtc_font_30]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor themeBlue] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickedAtButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
- (UIButton *)buttonTitle:(NSString *)title image:(UIImage *)image selectImg:(UIImage *)selectImg {
    UIButton *button = [UIButton new];
    
    button.layer.borderColor = [UIColor mtc_colorWithW:194].CGColor;
    button.layer.borderWidth = 0.5;
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectImg forState:UIControlStateSelected];
    [button setImage:selectImg forState:UIControlStateHighlighted];
    
    [button.titleLabel setFont:[UIFont mtc_font_30]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor themeBlue] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor themeBlue] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(clickedAtButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Initializer
- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end

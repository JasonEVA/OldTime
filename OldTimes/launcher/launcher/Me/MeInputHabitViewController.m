//
//  MeInputHabitViewController.m
//  launcher
//
//  Created by williamzhang on 15/12/2.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeInputHabitViewController.h"
#import "UnifiedUserInfoManager.h"
#import "InputHabitButton.h"
#import <Masonry/Masonry.h>
#import "Category.h"
#import "MyDefine.h"

@interface MeInputHabitViewController ()

@property (nonatomic, strong) NSArray *array;

@end

@implementation MeInputHabitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LOCAL(CHAT_INPUTHABIT_SETTING);
    self.view.backgroundColor = [UIColor grayBackground];
    
    UIView *lastView = nil;
    for (InputHabitButton *button in self.array) {
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@168);
            
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(15);
            } else {
                make.top.equalTo(self.view).offset(15);
            }
        }];

        lastView = button;
    }
    
    [self setSelectStyle];
}

#pragma mark - Private Method
- (void)setSelectStyle {
    InputHabitButton *button1 = [self.array firstObject];
    InputHabitButton *button2 = [self.array lastObject];
    
    InputHabitMode inputHabit = [[UnifiedUserInfoManager share] inputHabit];
    button1.selected = inputHabit == kInputHabitLineBreak;
    button2.selected = inputHabit == kInputHabitSend;
}

#pragma mark - Button Click
- (void)clickToSelect:(InputHabitButton *)button {
    [[UnifiedUserInfoManager share] setInputHabit:button.tag];
    [self setSelectStyle];
}

#pragma mark - Creater
- (InputHabitButton *)createButtonImageName:(NSString *)imageName title:(NSString *)title roundColor:(UIColor *)roundColor {
    InputHabitButton *button = [[InputHabitButton alloc] init];
    
    [button.imageView setImage:[UIImage imageNamed:imageName]];
    [button.titleLabel setText:title];
    [button.roundView setTintColor:roundColor];
    [button addTarget:self action:@selector(clickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (NSArray *)getAllHabits {
    InputHabitButton *button1 = [self createButtonImageName:@"Me_Input_LineBreak" title:LOCAL(CHAT_BREAKLINE) roundColor:[UIColor themeGreen]];
    InputHabitButton *button2 = [self createButtonImageName:@"Me_Input_Send" title:LOCAL(SEND) roundColor:[UIColor themeBlue]];

    [button1 setTag:1];
    [button2 setTag:2];
    
    return @[button1, button2];
}

#pragma mark - Initializer
- (NSArray *)array {
    if (!_array) {
        _array = [self getAllHabits];
    }
    return _array;
}

@end

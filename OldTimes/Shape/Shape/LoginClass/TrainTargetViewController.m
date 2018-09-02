//
//  TrainTargetViewController.m
//  Shape
//
//  Created by jasonwang on 15/10/16.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "TrainTargetViewController.h"
#import "MyDefine.h"
#import <Masonry.h>
#import "UIColor+Hex.h"
#import "PersonalDataViewController.h"
#import "UIButton+EX.h"

#define OFFSET 80
#define FONT 16

typedef NS_ENUM(NSInteger, buttonTag) {
    subtractBtnTag = 1000,
    moldingBtnTag,
    muscleBtnTag
    
};

static NSString *const backImg = @"login_back";

@interface TrainTargetViewController ()
@property (nonatomic, strong) UIButton *subtractBtn;  //减脂
@property (nonatomic, strong) UIButton *moldingBtn;   //塑型
@property (nonatomic, strong) UIButton *muscleBtn;    //增肌

@end

@implementation TrainTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"设置训练目标"];
        [self initComponent];
    [self.view needsUpdateConstraints];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event Respons

- (void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case subtractBtnTag:
            NSLog(@"我要减脂");
            break;
        case moldingBtnTag:
            NSLog(@"我要塑形");
            break;
        case muscleBtnTag:
            NSLog(@"我要增肌");
            break;
            
        default:
            break;
    }
    
    PersonalDataViewController *perVC = [[PersonalDataViewController alloc]init];
    [self.navigationController pushViewController:perVC animated:YES];
    
}

#pragma mark - initComponent

- (void)initComponent
{
    [self.view addSubview:self.subtractBtn];
    [self.view addSubview:self.muscleBtn];
    [self.view addSubview:self.moldingBtn];
}

#pragma mark - updateViewConstraints

- (void)updateViewConstraints
{
    [self.subtractBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(110);
        make.left.equalTo(self.view).offset(OFFSET);
        make.right.equalTo(self.view).offset(-OFFSET);
        make.height.mas_equalTo(height_44);
    }];
    
    [self.moldingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtractBtn.mas_bottom).offset(36);
        make.left.right.height.equalTo(self.subtractBtn);
    }];
    
    [self.muscleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moldingBtn.mas_bottom).offset(36);
        make.left.right.height.equalTo(self.subtractBtn);
    }];
    [super updateViewConstraints];
}

#pragma mark - init UI

- (UIButton *)subtractBtn
{
    if (!_subtractBtn) {
        _subtractBtn = [UIButton setBntData:_subtractBtn backColor:[UIColor themeBackground_373737] backImage:nil title:@"减脂" titleColorNormal:nil titleColorSelect:nil font:nil tag:subtractBtnTag isSelect:NO];
        [_subtractBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subtractBtn;
}

- (UIButton *)moldingBtn
{
    if (!_moldingBtn) {
        _moldingBtn = [UIButton setBntData:_moldingBtn backColor:[UIColor themeBackground_373737] backImage:nil title:@"塑形" titleColorNormal:nil titleColorSelect:nil font:nil tag:moldingBtnTag isSelect:NO];
        [_moldingBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moldingBtn;
}

- (UIButton *)muscleBtn
{
    if (!_muscleBtn) {
        _muscleBtn = [UIButton setBntData:_muscleBtn backColor:[UIColor themeBackground_373737] backImage:nil title:@"增肌" titleColorNormal:nil titleColorSelect:nil font:nil tag:muscleBtnTag isSelect:NO];
        [_muscleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _muscleBtn;
}
@end

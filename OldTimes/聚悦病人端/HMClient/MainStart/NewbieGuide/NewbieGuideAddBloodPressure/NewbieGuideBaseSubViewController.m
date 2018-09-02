//
//  NewbieGuideBaseSubViewController.m
//  HMClient
//
//  Created by Andrew Shen on 2016/11/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewbieGuideBaseSubViewController.h"

@interface NewbieGuideBaseSubViewController ()

@property (nonatomic, strong)  UIImageView  *backgroundImageView; // <##>
@property (nonatomic, strong)  UIButton  *skipButton; // <##>
@property (nonatomic, copy)  NewbieGuidePushNextCompletion  pushNextBlock; // <##>
@property (nonatomic, copy)  NewbieGuideSkipCompletion  skipBlock; // <##>
@end

@implementation NewbieGuideBaseSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_configElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

- (void)configBackgroundImageView:(NSString *)imageName {
    [self.backgroundImageView setImage:[UIImage imageNamed:imageName]];
}

- (void)hideSkipButton:(BOOL)hide {
    self.skipButton.hidden = hide;
}

// 滚轮滚动完毕
- (void)pickerViewScrollComplete {
    if (self.pushNextBlock) {
        self.pushNextBlock(NSStringFromClass(self.class));
        self.pushNextBlock = nil;
    }
}

- (void)addNotiSkipCompletion:(NewbieGuideSkipCompletion)skipCompletion {
    self.skipBlock = skipCompletion;
}

- (void)addPushNextCompletion:(NewbieGuidePushNextCompletion)pushNextCompletion {
    self.pushNextBlock = pushNextCompletion;
}

#pragma mark - Private Method


// 设置元素控件
- (void)p_configElements {
    
    // 设置数据
    [self p_configData];
    
    // 设置约束
    [self p_configConstraints];
}

// 设置数据
- (void)p_configData {
    
}

// 设置约束
- (void)p_configConstraints {
    [self.view addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.backgroundImageView addSubview:self.skipButton];
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backgroundImageView).insets(UIEdgeInsetsMake(20, 5, 0, 0));
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}


#pragma mark - Event Response

- (void)skipButtonAction {
    if (self.skipBlock) {
        self.skipBlock();
    }
}

- (void)backgroundImageViewClicked {
    if (self.pushNextBlock) {
        self.pushNextBlock(NSStringFromClass(self.class));
    }
}

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - Init

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundImageViewClicked)];
        [_backgroundImageView addGestureRecognizer:gesture];
    }
    return _backgroundImageView;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipButton setImage:[UIImage imageNamed:@"newGuide_skip"] forState:UIControlStateNormal];
        [_skipButton addTarget:self action:@selector(skipButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}
@end

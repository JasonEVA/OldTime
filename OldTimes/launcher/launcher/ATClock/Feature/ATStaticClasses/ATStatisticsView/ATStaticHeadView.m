//
//  ATStaticHeadView.m
//  Clock
//
//  Created by Dariel on 16/7/20.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATStaticHeadView.h"
#import <Masonry.h>
#import "DQAlertView.h"

#import "UIColor+ATHex.h"
#import "ATSharedMacro.h"

@interface ATStaticHeadView()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) UILabel *normalLabelTitle;
@property (nonatomic, strong) UILabel *unnormalLabelTitle;

@property (nonatomic, strong) UILabel *clockDateLabel;
@property (nonatomic, strong) UILabel *workLabel;
@property (nonatomic, strong) UILabel *outWorkLabel;

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *redView;

@end

@implementation ATStaticHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        self.redView = [[UIView alloc] init];
        self.redView.backgroundColor = [UIColor colorWithRed:255/255.0 green:224/255.0 blue:226/255.0 alpha:1];
        
        [self addSubview:self.redView];
        
        self.blueView = [[UIView alloc] init];
        self.blueView.backgroundColor = [UIColor colorWithRed:200/255.0 green:236/255.0 blue:255/255.0 alpha:1];
        
        [self addSubview:self.blueView];
        
        self.backBtn = [[UIButton alloc] init];
        [self.backBtn setImage:[UIImage imageNamed:@"img_statisticsView_left"] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
        
        self.nextBtn = [[UIButton alloc] init];
        [self.nextBtn setImage:[UIImage imageNamed:@"img_statisticsView_right"] forState:UIControlStateNormal];
        self.nextBtn.hidden = YES;
        [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.nextBtn];
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.font = [UIFont systemFontOfSize:15];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.textColor = [UIColor at_blackColor];
        [self addSubview:self.dateLabel];
        
        self.normalLabelTitle = [[UILabel alloc] init];
        self.normalLabelTitle.textColor = [UIColor at_blueColor];
        self.normalLabelTitle.textAlignment = NSTextAlignmentCenter;
        self.normalLabelTitle.text = @"正常考勤";
        [self.blueView addSubview:self.normalLabelTitle];
        
        self.normalLabelNum = [[UILabel alloc] init];
        self.normalLabelNum.textColor = [UIColor at_blueColor];
        self.normalLabelNum.textAlignment = NSTextAlignmentCenter;
        self.normalLabelNum.font = [UIFont systemFontOfSize:20];
        [self.blueView addSubview:self.normalLabelNum];
        
        
        self.unnormalLabelTitle = [[UILabel alloc] init];
        self.unnormalLabelTitle.textColor = [UIColor at_redColor];
        self.unnormalLabelTitle.textAlignment = NSTextAlignmentCenter;
        self.unnormalLabelTitle.text = @"异常考勤";
        [self.redView addSubview:self.unnormalLabelTitle];
        
        self.unnormalLabelNum = [[UILabel alloc] init];
        self.unnormalLabelNum.textColor = [UIColor at_redColor];
        self.unnormalLabelNum.textAlignment = NSTextAlignmentCenter;
        self.unnormalLabelNum.font = [UIFont systemFontOfSize:20];
        [self.redView addSubview:self.unnormalLabelNum];
        
        
        self.clockDateLabel = [[UILabel alloc] init];
        self.clockDateLabel.text = @"打卡日期";
        self.clockDateLabel.textColor = [UIColor at_blackColor];
        [self addSubview:self.clockDateLabel];
        
        
        self.workLabel = [[UILabel alloc] init];
        self.workLabel.text = @"上班";
        self.workLabel.textColor = [UIColor at_blackColor];
        [self addSubview:self.workLabel];
        
        self.outWorkLabel = [[UILabel alloc] init];
        self.outWorkLabel.text = @"下班";
        self.outWorkLabel.textColor = [UIColor at_blackColor];
        [self addSubview:self.outWorkLabel];
        
        [self initConstraints];
        
    }
    return self;
}

- (void)initConstraints {
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(18);
        make.centerX.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@25);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dateLabel.mas_left).offset(-15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.dateLabel);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLabel.mas_right).offset(15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.dateLabel);
    }];
    
    
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH/2.0));
        make.height.equalTo(@100);
        make.left.equalTo(self);
        make.top.equalTo(@60);
    }];
    
    
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(SCREEN_WIDTH/2.0));
        make.height.equalTo(@100);
        make.right.equalTo(self);
        make.top.equalTo(@60);
    }];
    
    [self.normalLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@70);
        make.centerX.equalTo(self.blueView);
        make.top.equalTo(self.blueView).offset(20);
    }];
    
    [self.normalLabelNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.blueView);
        make.top.equalTo(self.normalLabelTitle.mas_bottom).offset(15);
        
    }];
    
    
    [self.unnormalLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@70);
        make.centerX.equalTo(self.redView);
        make.top.equalTo(self.redView).offset(20);
    }];
    
    [self.unnormalLabelNum mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.centerX.equalTo(self.redView);
        make.top.equalTo(self.normalLabelTitle.mas_bottom).offset(15);
        
    }];
    
    [self.clockDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@70);
        make.height.equalTo(@20);
        make.left.equalTo(@35);
        make.top.equalTo(self.blueView.mas_bottom).offset(20);
    }];
    
    [self.workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@40);
        make.height.equalTo(@20);
        make.centerX.equalTo(self);
        make.top.equalTo(self.blueView.mas_bottom).offset(20);
        
    }];
    
    [self.outWorkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@40);
        make.height.equalTo(@20);
        make.right.equalTo(self).offset(-50);
        make.top.equalTo(self.blueView.mas_bottom).offset(20);
    }];
}

- (void)backBtnClick {

    if (self.delegate && [self.delegate respondsToSelector:@selector(changeDate:isAddMouth:nextButton:)]) {
        [self.delegate changeDate:self.dateLabel isAddMouth:NO nextButton:self.nextBtn];
    }

}

- (void)nextBtnClick {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeDate:isAddMouth:nextButton:)]) {
        [self.delegate changeDate:self.dateLabel isAddMouth:YES nextButton:self.nextBtn];
    }

}


@end


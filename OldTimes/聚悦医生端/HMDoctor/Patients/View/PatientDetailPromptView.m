//
//  PatientDetailPromptView.m
//  HMDoctor
//
//  Created by lkl on 2017/7/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "PatientDetailPromptView.h"
#import "UIBarButtonItem+BackExtension.h"


@interface PatientDetailPromptView ()

@property (nonatomic, strong) UIImageView *pointImgView;
@property (nonatomic, strong) UIImageView *btnImgView;
@end

@implementation PatientDetailPromptView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8]];
        [self addSubview:self.pointImgView];
        [self.pointImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(23);
            make.right.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(300, 156));
        }];
        
        [self addSubview:self.btnImgView];
        [self.btnImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_pointImgView.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(200, 45));
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeGesture:)];
        [_btnImgView addGestureRecognizer:tapGesture];
        _btnImgView.userInteractionEnabled = YES;
    }
    return self;
}

#pragma mark - Button Click
- (void)closeGesture:(UITapGestureRecognizer *)gesture {
    [self removeFromSuperview];
}


#pragma mark -- init
- (UIImageView *)pointImgView
{
    if (!_pointImgView) {
        _pointImgView = [UIImageView new];
        [_pointImgView setImage:[UIImage imageNamed:@"img_guide_patient_file_1"]];
    }
    return _pointImgView;
}

- (UIImageView *)btnImgView
{
    if (!_btnImgView) {
        _btnImgView = [UIImageView new];
        [_btnImgView setImage:[UIImage imageNamed:@"img_guide_know"]];
    }
    return _btnImgView;
}
@end


@interface PatientDetailNavigationView ()

@end

@implementation PatientDetailNavigationView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor mainThemeColor]];
        
        [self addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(10);
            make.left.equalTo(self).offset(15);
        }];
        
        
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.centerX.equalTo(self);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/2);
        }];
        
        [self addSubview:self.followBtn];
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titleLabel.mas_left).offset(-10);
            make.centerY.equalTo(self.backBtn);
        }];
        
        [self addSubview:self.historyMsgBtn];
        [self.historyMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.right.equalTo(self).offset(-15);
        }];
        
        [self addSubview:self.archiveBtn];
        [self.archiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.right.equalTo(_historyMsgBtn.mas_left).offset(-15);
        }];
    }
    return self;
}

#pragma mark -- init

- (UIButton *)buttonWithImageNamed:(NSString *)imageNamed
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:imageNamed] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(0, 0, button.currentBackgroundImage.size.width, button.currentBackgroundImage.size.height);
    return button;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [self buttonWithImageNamed:@"back"];
    }
    return _backBtn;
}

- (UIButton *)followBtn{
    if (!_followBtn) {
        _followBtn = [self buttonWithImageNamed:@""];
    }
    return _followBtn;
}

- (UIButton *)historyMsgBtn{
    if (!_historyMsgBtn) {
        _historyMsgBtn = [self buttonWithImageNamed:@"patient_historyMsg"];
    }
    return _historyMsgBtn;
}

- (UIButton *)archiveBtn{
    if (!_archiveBtn) {
        _archiveBtn = [self buttonWithImageNamed:@"icon_patient_file"];
    }
    return _archiveBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:[UIFont font_32]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

@end

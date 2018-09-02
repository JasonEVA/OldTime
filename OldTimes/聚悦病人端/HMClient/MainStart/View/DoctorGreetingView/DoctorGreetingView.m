//
//  DoctorGreetingView.m
//  HMClient
//
//  Created by Andrew Shen on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DoctorGreetingView.h"
#import <AVFoundation/AVFoundation.h>
#import "ATAudioSessionPlayUtility.h"


@interface DoctorGreetingView ()
@property (nonatomic, strong)  UIView  *doctorInfoContainer; // <##>
@property (nonatomic, strong)  UIImageView  *avatar; // <##>
@property (nonatomic, strong)  UILabel  *name; // <##>
@property (nonatomic, strong)  UILabel  *position; // <##>
@property (nonatomic, strong)  UILabel  *greetingMessage; // <##>
@property (nonatomic, strong)  UIView  *line; // <##>
@property (nonatomic, strong)  UIButton  *btnVoiceGreeting; // <##>
@property (nonatomic)  BOOL  playing; // <##>
@end

@implementation DoctorGreetingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configElements];
    }
    return self;
}

// 设置元素控件
- (void)configElements {
    [self addSubview:self.doctorInfoContainer]; // <##>
    [self.doctorInfoContainer addSubview:self.avatar]; // <##>
    [self.doctorInfoContainer addSubview:self.name]; // <##>
    [self.doctorInfoContainer addSubview:self.position]; // <##>
    [self addSubview:self.greetingMessage]; // <##>
    [self addSubview:self.line]; // <##>
    [self addSubview:self.btnVoiceGreeting]; // <##>    // 设置数据
    
    [self configData];
    
    // 设置约束
    [self configConstraints];
}

// 设置约束
- (void)configConstraints {
    [self.doctorInfoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.greaterThanOrEqualTo(@145);
        make.height.lessThanOrEqualTo(@200);
    }];
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.doctorInfoContainer);
        make.top.greaterThanOrEqualTo(self.doctorInfoContainer).offset(15);
        make.top.lessThanOrEqualTo(self.doctorInfoContainer).offset(30);
        make.width.height.mas_equalTo(85);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatar);
        make.top.equalTo(self.avatar.mas_bottom).offset(15);
    }];
    [self.position mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(5);
        make.centerX.equalTo(self.avatar);
        make.bottom.equalTo(self.doctorInfoContainer).offset(-15);
    }];
    
    [self.greetingMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.top.greaterThanOrEqualTo(self.doctorInfoContainer.mas_bottom).offset(10);
        make.top.lessThanOrEqualTo(self.doctorInfoContainer.mas_bottom).offset(30);
        make.right.equalTo(self).offset(-30);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.greetingMessage);
        make.top.greaterThanOrEqualTo(self.greetingMessage.mas_bottom).offset(10);
        make.top.lessThanOrEqualTo(self.greetingMessage.mas_bottom).offset(30);
        make.height.mas_equalTo(1);
    }];
    
    [self.btnVoiceGreeting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.line.mas_bottom);
        make.bottom.equalTo(self);
        make.height.greaterThanOrEqualTo(@70);
        make.height.lessThanOrEqualTo(@130);
    }];
}

// 设置数据
- (void)configData {

}

// 播放语音问候
- (void)playVoiceGreeting {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"WAV"];
    [[ATAudioSessionPlayUtility sharedInstance] playVoiceWithPath:path];
}


#pragma mark - Init 

- (UIView *)doctorInfoContainer {
    if (!_doctorInfoContainer) {
        _doctorInfoContainer = [UIView new];
        _doctorInfoContainer.backgroundColor = [UIColor mainThemeColor];
        [_doctorInfoContainer setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _doctorInfoContainer;
}

- (UIImageView *)avatar {
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_32"]];
        _avatar.layer.cornerRadius = 42.5;
        _avatar.clipsToBounds = YES;
    }
    return _avatar;
}

- (UILabel *)name {
    if (!_name) {
        _name = [UILabel new];
        _name.textColor = [UIColor whiteColor];
        _name.font = [UIFont systemFontOfSize:20];
        _name.text= @"李大海";
    }
    return _name;
}

- (UILabel *)position {
    if (!_position) {
        _position = [UILabel new];
        _position.textColor = [UIColor whiteColor];
        _position.font = [UIFont font_34];
        _position.text = @"教授";
    }
    return _position;
}

- (UILabel *)greetingMessage {
    if (!_greetingMessage) {
        _greetingMessage = [UILabel new];
        _greetingMessage.textColor = [UIColor blackColor];
        _greetingMessage.font = [UIFont systemFontOfSize:18];
        _greetingMessage.numberOfLines = 2;
        _greetingMessage.lineBreakMode = NSLineBreakByWordWrapping;
        [_greetingMessage setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _greetingMessage.text = @"最近两天血压有点偏高哦，注意不要吃得太油腻";
    }
    return _greetingMessage;
}

- (UIView *)line {
    if (!_line) {

    }
    return _line;
}

- (UIButton *)btnVoiceGreeting {
    if (!_btnVoiceGreeting) {
        _btnVoiceGreeting = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnVoiceGreeting setImage:[UIImage imageNamed:@"icon_voiceGreeting"] forState:UIControlStateNormal];
        [_btnVoiceGreeting setTitle:@"语音问候" forState:UIControlStateNormal];
        _btnVoiceGreeting.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_btnVoiceGreeting setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [_btnVoiceGreeting.titleLabel setFont:[UIFont font_34]];
        _btnVoiceGreeting.imageEdgeInsets = UIEdgeInsetsMake(-30, 60, 0, 0);
        _btnVoiceGreeting.titleEdgeInsets = UIEdgeInsetsMake(30, -32, 0, 0);
        [_btnVoiceGreeting addTarget:self action:@selector(playVoiceGreeting) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnVoiceGreeting;
}

@end


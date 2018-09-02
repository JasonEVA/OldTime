//
//  HMHistoryCollectVoiceTableViewCell.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/4.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMHistoryCollectVoiceTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@interface HMHistoryCollectVoiceTableViewCell ()
@property (nonatomic, retain) UIButton* voiceControl;                //语音view

@property (nonatomic, retain) UILabel* lbDuration;
//语音时间
@property (nonatomic, retain) UIImageView* ivVoice;
//语音图片


@end
@implementation HMHistoryCollectVoiceTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.voiceControl];
        [self.voiceControl addSubview:self.ivVoice];
        [self.voiceControl addSubview:self.lbDuration];
        
        [self configElements];
    }
    return self;
}

#pragma mark -private method
- (void)configElements {
    
    [self.voiceControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView);
        make.top.equalTo(self.iconView.mas_bottom).offset(15);
        make.height.equalTo(@44);
        make.width.mas_equalTo(120);
        make.bottom.equalTo(self.contentView).offset(-15);

    }];
    
    [_ivVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_voiceControl).with.offset(10);
        make.centerY.equalTo(_voiceControl);
    }];
    
    [_lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_voiceControl);
        make.right.equalTo(_voiceControl.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
}
#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)setDataWithModel:(MessageBaseModel *)model {
    [self setBaseDataWithModel:model];
    NSDictionary *dict = model._content.mj_JSONObject;
    [self.lbDuration setText:[NSString stringWithFormat:@"%ld''",[dict[@"audioLength"] integerValue]?:1]];
    [self configElements];
}

// 播放声音的动画
- (void)startPlayVoiceWithTime:(CGFloat)lenght
{
    self.ivVoice.animationRepeatCount = lenght * 2;
    self.ivVoice.animationDuration = 0.5;
    [self.ivVoice startAnimating];
}

- (void)stopPlayVoice {
    [self.ivVoice stopAnimating];
}
#pragma mark - init UI
- (UIButton *)voiceControl {
    if (!_voiceControl) {
        _voiceControl = [UIButton new];
        [_voiceControl setBackgroundImage:[UIImage imageNamed:@"concern_yuyin"] forState:UIControlStateNormal];
        [_voiceControl.layer setCornerRadius:8.0f];
        [_voiceControl.layer setMasksToBounds:YES];
        [_voiceControl setUserInteractionEnabled:NO];
//        [_voiceControl addTarget:self action:@selector(palyVoice) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceControl;
}

- (UIImageView *)ivVoice {
    if (!_ivVoice) {
        _ivVoice = [UIImageView new];
        [_ivVoice setImage:[UIImage imageNamed:@"icon_voice_1"]];
        
        [_ivVoice setAnimationImages:@[[UIImage imageNamed:@"icon_voice_3"],
                                       [UIImage imageNamed:@"icon_voice_2"],
                                       [UIImage imageNamed:@"icon_voice_1"],
                                       ]];
        
        _ivVoice.animationDuration = 1.5;
        _ivVoice.animationRepeatCount = 0;
    }
    return _ivVoice;
}

- (UILabel *)lbDuration {
    if (!_lbDuration) {
        _lbDuration = [UILabel new];
        [_lbDuration setText:@"2''"];
        [_lbDuration setFont:[UIFont systemFontOfSize:14]];
        [_lbDuration setTextColor:[UIColor whiteColor]];
        [_lbDuration setTextAlignment:NSTextAlignmentCenter];
    }
    return _lbDuration;
}

@end

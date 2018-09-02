//
//  CareVoiceRecordVolumeView.m
//  HMDoctor
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CareVoiceRecordVolumeView.h"

@interface CareVoiceRecordVolumeView ()
{
    UIImageView *ivVoice;
    NSMutableArray *soundBrickArray;
    UILabel *lbContent;
}
@property (nonatomic, strong) UIView *backView;
@end

@implementation CareVoiceRecordVolumeView

- (id) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.3]];
        self.backView = [UIView new];
        [self.backView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75]];
        [self.backView.layer setCornerRadius:8];
        [self.backView.layer setMasksToBounds:YES];
        
        [self addSubview:self.backView];
        
        lbContent = [[UILabel alloc] init];
        [self.backView addSubview:lbContent];
        [lbContent setText:@"录制音频"];
        [lbContent setFont:[UIFont systemFontOfSize:16]];
        [lbContent setTextColor:[UIColor whiteColor]];
        [lbContent setTextAlignment:NSTextAlignmentCenter];
        
        ivVoice = [[UIImageView alloc] init];
        [self.backView addSubview:ivVoice];
        [ivVoice setImage:[UIImage imageNamed:@"icon_customer_service_audio1"]];
        
        [ivVoice setAnimationImages:@[
                                [UIImage imageNamed:@"icon_customer_service_audio1"],
                                [UIImage imageNamed:@"icon_customer_service_audio2"],
                                [UIImage imageNamed:@"icon_customer_service_audio3"],
                              
                                ]];
        
        ivVoice.animationDuration = 1.5;
        ivVoice.animationRepeatCount = 0;
        [ivVoice  startAnimating];
        
        _lbDuration = [[UILabel alloc]init];
        [self.backView addSubview:_lbDuration];
        [_lbDuration setText:@"00:00"];
        [_lbDuration setFont:[UIFont systemFontOfSize:14]];
        [_lbDuration setTextColor:[UIColor whiteColor]];
        
        [self subViewsLayout];
    }
    return self;
}


- (void) subViewsLayout
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self).offset(20);
        make.height.mas_equalTo(132);
    }];
    
    [lbContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).with.offset(10);
        make.left.equalTo(self.backView).with.offset(15);
        make.height.mas_equalTo(20);
    }];

    [ivVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbContent.mas_bottom).with.offset(20);
        make.left.equalTo(self.backView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(270*kScreenScale, 35));
    }];
    
    [_lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).with.offset(10);
        make.top.equalTo(ivVoice.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
}


@end

@interface CareVoiceMessageView ()
{

}
@end

@implementation CareVoiceMessageView

- (id) init
{
    self = [super init];
    if (self)
    {
        _voiceControl = [[UIControl alloc] init];
        [self addSubview:_voiceControl];
        [_voiceControl setBackgroundColor:[UIColor mainThemeColor]];
        [_voiceControl.layer setCornerRadius:8.0f];
        [_voiceControl.layer setMasksToBounds:YES];
        
        _ivVoice = [[UIImageView alloc] init];
        [_voiceControl addSubview:_ivVoice];
        [_ivVoice setImage:[UIImage imageNamed:@"icon_voice_1"]];
        
        [_ivVoice setAnimationImages:@[[UIImage imageNamed:@"icon_voice_3"],
                                      [UIImage imageNamed:@"icon_voice_2"],
                                      [UIImage imageNamed:@"icon_voice_1"],
                                      ]];
        
        _ivVoice.animationDuration = 1.5;
        _ivVoice.animationRepeatCount = 0;
        
        _lbDuration = [[UILabel alloc]init];
        [_voiceControl addSubview:_lbDuration];
        [_lbDuration setText:@"2''"];
        [_lbDuration setFont:[UIFont systemFontOfSize:14]];
        [_lbDuration setTextColor:[UIColor whiteColor]];
        [_lbDuration setTextAlignment:NSTextAlignmentCenter];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_deleteButton];
        [_deleteButton setTitleColor:[UIColor commonRedColor] forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        
        [self subViewsLayout];
        
    }
    return self;
}

- (void)subViewsLayout
{
    [_voiceControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.5);
        make.top.height.equalTo(self);
        make.width.mas_equalTo(120);
    }];
    
    [_ivVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_voiceControl).with.offset(10);
        make.centerY.equalTo(_voiceControl);
        make.width.equalTo(@25);
    }];
    
    [_lbDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_voiceControl);
        make.right.equalTo(_voiceControl.mas_right).with.offset(-10);
        make.left.lessThanOrEqualTo(_ivVoice.mas_right).offset(20);
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_voiceControl.mas_right).with.offset(20);
        make.centerY.equalTo(self);
    }];
}

@end

@interface CareVoiceRecordView ()
{
    UIImageView *ivVoiceIcon;
    UILabel* lbMessage;
}
@end

@implementation CareVoiceRecordView

- (id) init
{
    self = [super init];
    if (self)
    {
        ivVoiceIcon = [[UIImageView alloc] init];
        [self addSubview:ivVoiceIcon];
        [ivVoiceIcon setImage:[UIImage imageNamed:@"concern_luyin"]];
        
        _voiceIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_voiceIconButton];
        //[_voiceIconButton setImage:[UIImage imageNamed:@"icon_mypatient_11"] forState:UIControlStateNormal];
        
        lbMessage = [[UILabel alloc] init];
        [self addSubview:lbMessage];
        [lbMessage setText:@"长按开始录音"];
        [lbMessage setFont:[UIFont systemFontOfSize:15]];
        [lbMessage setTextColor:[UIColor commonGrayTextColor]];
        
        [ivVoiceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [_voiceIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [lbMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_voiceIconButton.mas_bottom).with.offset(10);
            make.centerX.equalTo(self);
        }];
    }
    return self;
    
}

@end


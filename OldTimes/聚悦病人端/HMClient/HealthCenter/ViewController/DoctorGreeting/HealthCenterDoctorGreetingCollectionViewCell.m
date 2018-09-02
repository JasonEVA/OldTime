//
//  HealthCenterDoctorGreetingCollectionViewCell.m
//  HMClient
//
//  Created by lkl on 16/6/22.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterDoctorGreetingCollectionViewCell.h"
#import "DoctorGreetingView.h"
#import "ATAudioSessionPlayUtility.h"
#import "AudioPlayHelper.h"
#import "EncodeAudio.h"

@interface HealthCenterDoctorGreetingCollectionViewCell()
{
    UIView* bgView;
    UIImageView* headerImage;
    UILabel* lbstaffName;
    UILabel* lbjobTitle;
    UITextView* lbgreetingMessage;
    UIView* lineView;
    UIButton* voiceButton;
    
    DoctorGreetingInfo *greeting;
}
@property (nonatomic) BOOL isDownLoading;
@end

@implementation HealthCenterDoctorGreetingCollectionViewCell

- (void)dealloc {
    [[AudioPlayHelper shareInstance] stopPlay];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:8.0f];
        [self.layer setMasksToBounds:YES];
        
        bgView = [[UIView alloc] init];
        [self addSubview:bgView];
        [bgView setBackgroundColor:[UIColor mainThemeColor]];
        [bgView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

        headerImage = [[UIImageView alloc] init];
        //[headerImage setImage:[UIImage imageNamed:@"icon_32"]];
        [self addSubview:headerImage];
        headerImage.layer.cornerRadius = 42.5;
        headerImage.clipsToBounds = YES;
        
        lbstaffName = [[UILabel alloc] init];
        [self addSubview:lbstaffName];
        [lbstaffName setTextColor:[UIColor whiteColor]];
        [lbstaffName setFont:[UIFont systemFontOfSize:20]];
        //[lbstaffName setText:@"常静静"];
        
        lbjobTitle = [[UILabel alloc] init];
        [self addSubview:lbjobTitle];
        [lbjobTitle setTextColor:[UIColor whiteColor]];
        [lbjobTitle setFont:[UIFont font_32]];
        //[lbjobTitle setText:@"专家"];
        
        lbgreetingMessage = [[UITextView alloc] init];
        [self addSubview:lbgreetingMessage];
        lbgreetingMessage.textColor = [UIColor blackColor];
        lbgreetingMessage.font = [UIFont systemFontOfSize:18];
        [lbgreetingMessage setEditable:NO];
//        [lbgreetingMessage setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        //lbgreetingMessage.text = @"测试测试发送的消息";
        
        lineView = [[UIView alloc] init];
        [self addSubview:lineView];
        lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:voiceButton];
        [voiceButton setImage:[UIImage imageNamed:@"icon_voiceGreeting"] forState:UIControlStateNormal];
        [voiceButton setTitle:@"语音问候" forState:UIControlStateNormal];
        voiceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [voiceButton setTitleColor:[UIColor mainThemeColor] forState:UIControlStateNormal];
        [voiceButton.titleLabel setFont:[UIFont font_34]];
        voiceButton.imageEdgeInsets = UIEdgeInsetsMake(-30, 80, 0, 0);
        voiceButton.titleEdgeInsets = UIEdgeInsetsMake(30, -32, 0, 0);
        [voiceButton addTarget:self action:@selector(playVoiceGreeting) forControlEvents:UIControlEventTouchUpInside];

        [self subViewsLayout];
    }
    return self;
}

- (void)subViewsLayout
{
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.greaterThanOrEqualTo(@145);
        make.height.lessThanOrEqualTo(@200);
    }];
    
    [headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.greaterThanOrEqualTo(bgView).offset(15);
        make.top.lessThanOrEqualTo(bgView).offset(30);
        make.width.height.mas_equalTo(85);
    }];
    
    [lbstaffName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImage);
        make.top.equalTo(headerImage.mas_bottom).offset(15);
    }];
    
    [lbjobTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lbstaffName.mas_bottom).offset(5);
        make.centerX.equalTo(headerImage);
        make.bottom.equalTo(bgView).offset(-15);
    }];
    
    [lbgreetingMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.top.greaterThanOrEqualTo(bgView.mas_bottom).offset(10);
        make.top.lessThanOrEqualTo(bgView.mas_bottom).offset(30);
        make.right.equalTo(self).offset(-30);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(lbgreetingMessage);
        make.top.greaterThanOrEqualTo(lbgreetingMessage.mas_bottom).offset(10);
        make.top.lessThanOrEqualTo(lbgreetingMessage.mas_bottom).offset(30);
        make.height.mas_equalTo(1);
    }];
    
    [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(lineView.mas_bottom);
        make.bottom.equalTo(self);
        make.height.greaterThanOrEqualTo(@70);
        make.height.lessThanOrEqualTo(@130);
    }];
}

- (void)setDoctorGreetingData:(DoctorGreetingInfo *)greetingInfo
{
    if (greetingInfo.imgUrl)
    {
        [headerImage sd_setImageWithURL:[NSURL URLWithString:greetingInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"img_default_staff"]];
    }
    [lbgreetingMessage setText:greetingInfo.careCon];
    [lbstaffName setText:greetingInfo.carerName];
    [lbjobTitle setText:greetingInfo.carerTypeName];
    
    greeting = greetingInfo;
    [voiceButton setHidden:!greeting.voice.length];
    
}

- (void)playVoiceGreeting
{
    if (greeting)
    {
        NSString* string = greeting.voice;
        if (self.isDownLoading) {
            return;
        }
        if ([[AudioPlayHelper shareInstance] isPlaying]) {
            [[AudioPlayHelper shareInstance] stopPlay];
            return;
        }
        //
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            self.isDownLoading = YES;
            NSData* wavdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:greeting.voice]];
            //amr转wav播放
            NSData* armToWavData = [EncodeAudio convertAmrToWavFile:wavdata];
            
            dispatch_async(dispatch_get_main_queue(), ^{
              
                if (!wavdata)
                {
                    return;
                }
                if ([string containsString:@".wav"])
                {
                    [[AudioPlayHelper shareInstance] playAudioData:wavdata callBack:^{
                        
                    }];
                } else
                {
                    [[AudioPlayHelper shareInstance] playAudioData:armToWavData callBack:^{
                        
                    }];
                }
                self.isDownLoading = NO;

            });
        });
        
       
    }
}

@end

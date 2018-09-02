
//
//  NewChatLeftVoiceTableViewCell.m
//  launcher
//
//  Created by Lars Chen on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "NewChatLeftVoiceTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <Masonry.h>
//#import "Category.h"

#define MARGE 18            // 头像距边界的距离
#define MARGE_TOP 8           // 头像距顶部边界的距离

#define INTERVAL_VOICE 14   // 声音图片距气泡距离
#define INTERVAL 7          // 头像与气泡间隔
#define INTERVAL_LABEL 20    // 气泡与时间label距离

#define W_VOICE 18          // 声音图片宽度
#define W_HEADICON 42       // 头像宽度，与气泡高度一样
#define H_BUBBLE 42         // 气泡默认高度
#define W_TIME 50           // 时间宽度
#define MAX_W (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 气泡最大宽度
#define H_NAME 15           // 姓名高度

#define CHAT_BUBBLE         @"chat_left_bubble"         // 气泡
#define CHAT_VOICE_PLAYING0 @"chat_voice0"              // 播放0
#define CHAT_VOICE_PLAYING1 @"chat_left_voice1"         // 播放1
#define CHAT_VOICE_PLAYING2 @"chat_left_voice2"         // 播放2
#define CHAT_VOICE_PLAYING3 @"chat_left_voice3"         // 播放3,默认图案
#define IMG_UNREAD          [UIImage imageNamed:@"message_voice_unread"]

@interface NewChatLeftVoiceTableViewCell ()

@property (nonatomic, strong) NSArray     *arrayVoicePlaying;     // 语音播放icon
@property (nonatomic, strong) UIImageView *imgViewUnread;            // 未读圆圈
@property (nonatomic, strong) UILabel     *lbMessageTime;            // 语音时间
@property (nonatomic, strong) UIImageView *imgViewVoice;             // 语音波图片

@end

@implementation NewChatLeftVoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {

        [self.wz_contentView addSubview:self.imgViewUnread];
        [self.wz_contentView addSubview:self.lbMessageTime];
        [self.wz_contentView addSubview:self.imgViewVoice];
        
        [self.lbMessageTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imgViewBubble).offset(-14);
            make.centerY.equalTo(self.imgViewBubble);
        }];
        
        [self.imgViewVoice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgViewBubble).offset(INTERVAL_VOICE);
            make.centerY.equalTo(self.imgViewBubble);
        }];
        
        [self.imgViewUnread mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imgViewBubble).offset(2);
            make.top.equalTo(self.imgViewBubble).offset(-1);
        }];
    }
    
    return self;
}

#pragma mark - Interface Method
- (void)showVoiceMessageTime:(NSInteger)length unreadMark:(BOOL)unread
{
    NSInteger bubbleWidth = length * 5 + H_BUBBLE + 30;
    // 气泡图片
    UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
    img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
    [self.imgViewBubble mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(MIN(bubbleWidth, MAX_W)));
    }];
   
    // 未读小圆圈
    [_imgViewUnread setHidden:unread];
    
    length = length ?: 1;
    
    [_lbMessageTime setText:[NSString stringWithFormat:@"%ld''",(long)length]];
}

// 停止播放声音的动画
- (void)stopPlayVoice
{
    // 如果正在播放，就停止
    if (_imgViewVoice.isAnimating)
    {
        [_imgViewVoice stopAnimating];
    }
}

// 播放声音的动画
- (void)startPlayVoiceWithTime:(CGFloat)lenght
{
    _imgViewVoice.animationImages = self.arrayVoicePlaying;
    _imgViewVoice.animationRepeatCount = lenght * 2;
    _imgViewVoice.animationDuration = 0.5;
    [_imgViewVoice startAnimating];
}

#pragma mark - Initializer
- (UILabel *)lbMessageTime
{
    if (!_lbMessageTime)
    {
        _lbMessageTime = [[UILabel alloc] init];
        [_lbMessageTime setFont:[UIFont systemFontOfSize:12]];
        [_lbMessageTime setTextAlignment:NSTextAlignmentRight];
        [_lbMessageTime setTextColor:ChatBubbleLeftConfigShare.textColor];
        [_lbMessageTime setBackgroundColor:[UIColor clearColor]];
    }
    
    return _lbMessageTime;
}

- (UIImageView *)imgViewVoice
{
    if (!_imgViewVoice)
    {
        _imgViewVoice = [[UIImageView alloc] init];
        [_imgViewVoice setImage:[UIImage imageNamed:CHAT_VOICE_PLAYING3]];
        [_imgViewVoice setContentMode:UIViewContentModeCenter];
        _imgViewVoice.tintColor = ChatBubbleLeftConfigShare.textColor;
    }
    
    return _imgViewVoice;
}

- (UIImageView *)imgViewUnread
{
    if (!_imgViewUnread)
    {
        _imgViewUnread = [[UIImageView alloc] initWithImage:IMG_UNREAD];
        [_imgViewUnread.layer setCornerRadius:3.5];
        [_imgViewUnread.layer setMasksToBounds:YES];
    }
    
    return _imgViewUnread;
}

- (NSArray *)arrayVoicePlaying {
    if (!_arrayVoicePlaying) {
        _arrayVoicePlaying = @[[[UIImage imageNamed:CHAT_VOICE_PLAYING0] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],
                               [[UIImage imageNamed:CHAT_VOICE_PLAYING1] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],
                               [[UIImage imageNamed:CHAT_VOICE_PLAYING2] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate],
                               [[UIImage imageNamed:CHAT_VOICE_PLAYING3] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]
                               ];
    }
    return _arrayVoicePlaying;
}

@end

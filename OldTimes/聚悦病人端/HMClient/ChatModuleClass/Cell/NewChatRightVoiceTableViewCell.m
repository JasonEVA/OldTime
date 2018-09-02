//
//  NewChatRightVoiceTableViewCell.m
//  launcher
//
//  Created by Lars Chen on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "NewChatRightVoiceTableViewCell.h"
#import <Masonry/Masonry.h>
//#import "Category.h"
#import "Slacker.h"

#define MAX_W (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)            // 文本最大宽度
#define H_BUBBLE 42         // 气泡默认高度
#define INTERVAL_VOICE 14   // 声音图片距气泡距离
#define W_VOICE 18          // 声音图片宽度

#define CHAT_VOICE_PLAYING3 @"chat_right_voice3"         // 播放3

#define CHAT_VOICE_PLAYING0 @"chat_voice0"              // 播放0
#define CHAT_VOICE_PLAYING1 @"chat_right_voice1"         // 播放1
#define CHAT_VOICE_PLAYING2 @"chat_right_voice2"         // 播放2
#define CHAT_VOICE_PLAYING3 @"chat_right_voice3"         // 播放3

@interface NewChatRightVoiceTableViewCell ()

@property (nonatomic, strong) UIImageView *imgViewVoice;        // 语音波图片
@property (nonatomic, strong) UILabel *lbMessageTime;           // 消息时长度

@property (nonatomic, strong) MASConstraint *constraintBubbleWidth;

@property (nonatomic, strong) NSMutableArray *arrayVoicePlaying; // 语音播放icon

@end

@implementation NewChatRightVoiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {        
        [self.contentView addSubview:self.imgViewVoice];
        [self.contentView addSubview:self.lbMessageTime];
        
        [self.lbMessageTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgViewBubble).offset(14);
            make.centerY.equalTo(self.imgViewBubble);
        }];
        
        [self.imgViewVoice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imgViewBubble).offset(-INTERVAL_VOICE);
            make.centerY.equalTo(self.imgViewBubble);
        }];
        
        [self.imgViewBubble mas_makeConstraints:^(MASConstraintMaker *make) {
            self.constraintBubbleWidth = make.width.equalTo(@20);
            make.height.equalTo(@(H_BUBBLE));
        }];
        
        // 存放语音播放时的图片
        self.arrayVoicePlaying = [NSMutableArray arrayWithObjects:[UIImage imageNamed:CHAT_VOICE_PLAYING0],[UIImage imageNamed:CHAT_VOICE_PLAYING1], [UIImage imageNamed:CHAT_VOICE_PLAYING2], [UIImage imageNamed:CHAT_VOICE_PLAYING3], nil];
    }
    
    return self;
}

- (void)showVoiceMessageTime:(NSInteger)length
{
    NSInteger bubbleWidth = length * 5 + H_BUBBLE + 30;
    CGFloat maxWidth = MAX_W;
    self.constraintBubbleWidth.offset = MIN(bubbleWidth, maxWidth);
    [self.imgViewBubble layoutIfNeeded];
    
    length = length ?: 1;
    
    [self.lbMessageTime setText:[NSString stringWithFormat:@"%ld''",(long)length]];
}

// 播放声音的动画
- (void)startPlayVoiceWithTime:(CGFloat)lenght
{
    _imgViewVoice.animationImages = _arrayVoicePlaying;
    _imgViewVoice.animationRepeatCount = lenght * 2;
    _imgViewVoice.animationDuration = 0.5;
    [_imgViewVoice startAnimating];
    
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

- (UILabel *)lbMessageTime
{
    if (!_lbMessageTime)
    {
        _lbMessageTime = [[UILabel alloc] init];
        [_lbMessageTime setFont:[UIFont font_24]];
        [_lbMessageTime setTextAlignment:NSTextAlignmentRight];
        [_lbMessageTime setTextColor:ChatBubbleRightConfigShare.textColor];
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
        _imgViewVoice.tintColor = ChatBubbleRightConfigShare.textColor;
    }
    
    return _imgViewVoice;
}

@end

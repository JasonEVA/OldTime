//
//  ChatLeftVoiceTableViewCell.m
//  Titans
//
//  Created by Andrew Shen on 14-9-23.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatLeftVoiceTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <UIImageView+WebCache.h>
#import "QuickCreateManager.h"
#import <Masonry.h>

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

@implementation ChatLeftVoiceTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier Target:(id)target Action:(SEL)action ActionHead:(SEL)actionHead longPress:(SEL)longPress
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // 头像
        _imgViewHeadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGE, MARGE_TOP, W_HEADICON, W_HEADICON)];
        //        [_imgViewHeadIcon.layer setCornerRadius:W_HEADICON / 2];
        [_imgViewHeadIcon.layer setMasksToBounds:YES];
        [_imgViewHeadIcon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionHead];
        [_imgViewHeadIcon addGestureRecognizer:tapGesture];
        [self.contentView addSubview:_imgViewHeadIcon];
        
        // 气泡
        _imgViewBubble = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgViewBubble];
        
        // 为图片添加手势
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [_imgViewBubble setUserInteractionEnabled:YES];
        [_imgViewBubble addGestureRecognizer:tapGesture];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:longPress];
        [_imgViewBubble addGestureRecognizer:longGesture];

        
        // 声音波图片
        _imgViewVoice = [[UIImageView alloc] initWithFrame:CGRectMake(INTERVAL_VOICE, (H_BUBBLE - W_VOICE) / 2, W_VOICE, W_VOICE)];
        [_imgViewVoice setImage:[UIImage imageNamed:CHAT_VOICE_PLAYING3]];
        [_imgViewVoice setContentMode:UIViewContentModeCenter];
        [_imgViewBubble addSubview:_imgViewVoice];
        
        // 文字
        _lbTime = [[UILabel alloc] init];
        [_lbTime setFont:[UIFont systemFontOfSize:16]];
        [_lbTime setTextColor:[UIColor whiteColor]];
        [_lbTime setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_lbTime];
        
        // 存放语音播放时的图片
        _arrayVoicePlaying = [NSMutableArray arrayWithObjects:[UIImage imageNamed:CHAT_VOICE_PLAYING0],[UIImage imageNamed:CHAT_VOICE_PLAYING1], [UIImage imageNamed:CHAT_VOICE_PLAYING2], [UIImage imageNamed:CHAT_VOICE_PLAYING3], nil];
        
        // 未读小圆点
        _imgViewUnread = [QuickCreateManager creatImageViewWithFrame:CGRectMake(0, 0, 7, 7) Image:IMG_UNREAD];
        [_imgViewUnread.layer setCornerRadius:3.5];
        [_imgViewUnread.layer setMasksToBounds:YES];
        [self.contentView addSubview:_imgViewUnread];
        
        // 姓名
        _lbName = [[UILabel alloc] initWithFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + 10, MARGE_TOP, MAX_W, H_NAME)];
        [_lbName setFont:[UIFont systemFontOfSize:11]];
        [_lbName setTextColor:[UIColor grayColor]];
        [_lbName setBackgroundColor:[UIColor clearColor]];
        
        // 时间图案
        _lbMessageTime = [UILabel new];
        [_lbMessageTime setFont:[UIFont systemFontOfSize:13]];
        [_lbMessageTime setTextColor:[UIColor grayColor]];
        [self addSubview:_lbMessageTime];
        
        //重点标记
        _imgEmphasis = [[UIImageView alloc] init];
        _imgEmphasis.userInteractionEnabled = YES;
        _imgEmphasis.image = [UIImage imageNamed:@"emphasis"];
        _imgEmphasis.hidden = YES;
        [self.contentView addSubview:_imgEmphasis];

    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Interface Method
- (void)showVoiceMessageTime:(NSInteger)length Tag:(NSInteger)tag UnreadMark:(BOOL)unread
{
    NSInteger bubbleWidth = length * 5 + H_BUBBLE + 30;
    // 气泡图片
    UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
    img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
    [_imgViewBubble setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + INTERVAL, MARGE_TOP, MIN(bubbleWidth, MAX_W), H_BUBBLE)];
    [_imgViewBubble setImage:img];
    [_imgViewBubble setTag:tag];
    [_imgViewHeadIcon setTag:tag];
    
    // 时间显示
    //    [_lbTime setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewBubble.frame WithX:YES] + INTERVAL_LABEL, MARGE_TOP, W_TIME, H_BUBBLE)];
    [_lbTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_imgViewBubble).offset(-13);
        make.centerY.equalTo(_imgViewBubble);
    }];
    [_lbTime setText:[NSString stringWithFormat:@"%ld''",(long)length]];
    
    // 未读小圆圈
    [_imgViewUnread setHidden:unread];
    //    [_imgViewUnread setCenter:CGPointMake(_lbTime.frame.origin.x + 4, _lbTime.frame.origin.y + 5)];
    [_imgViewUnread mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgViewBubble.mas_right).offset(20);
        make.centerY.equalTo(_imgViewBubble).offset(-4);
    }];
    
    [_imgEmphasis mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgViewBubble.mas_top);
        make.left.equalTo(_imgViewBubble.mas_right).offset(20);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
    }];

}

// 显示时间
- (void)showDate:(NSString *)time
{
    [_lbMessageTime setText:time];
    [_lbMessageTime mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgViewBubble.mas_right).offset(13);
        make.bottom.equalTo(_imgViewBubble);
    }];
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

// 设置头像
- (void)setHeadIconWithUrl:(NSString *)imgUrl
{
    [_imgViewHeadIcon sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:IMG_PLACEHOLDER_HEAD];
}

// 设置姓名
- (void)setRealName:(NSString *)name hidden:(BOOL)hidden
{
    if (!hidden)
    {
        [_lbName setText:name];
        [self.contentView addSubview:_lbName];
        [_lbTime setCenter:CGPointMake(_lbTime.center.x, _lbTime.center.y + H_NAME)];
        [_imgViewUnread setCenter:CGPointMake(_imgViewUnread.center.x, _imgViewUnread.center.y + H_NAME)];
        [_imgViewBubble setCenter:CGPointMake(_imgViewBubble.center.x, _imgViewBubble.center.y + H_NAME)];
        
    }
    else
    {
        [_lbName removeFromSuperview];
        [_lbTime setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewBubble.frame WithX:YES] + INTERVAL_LABEL, MARGE_TOP, W_TIME, H_BUBBLE)];
        [_imgViewBubble setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + INTERVAL, MARGE_TOP, _imgViewBubble.frame.size.width, _imgViewBubble.frame.size.height)];
        [_imgViewUnread setCenter:CGPointMake(_lbTime.frame.origin.x + 4, _lbTime.frame.origin.y + 5)];
        
    }
}
//设置重点标志(是否展示)
- (void)setEmphasisIsShow:(BOOL)IsShow
{
    if (IsShow) {
        _imgEmphasis.hidden = NO;
    }else {
        _imgEmphasis.hidden = YES;
    }
}

@end

//
//  ChatRightVideoTableViewCell.m
//  PalmDoctorPT
//
//  Created by Lars Chen on 15/7/6.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "ChatRightVideoTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <UIImageView+WebCache.h>
#import "NSString+Manager.h"
#import <AVFoundation/AVFoundation.h>

#define MARGE 12            // 头像距边界的距离
#define MARGE_TOP 8         // 头像距顶部边界的距离

#define INTERVAL 7          // 头像与图片间隔
#define INTERVAL_LOADING 20 // 图片与旋转框距离
#define W_HEADICON 42       // 头像宽度
#define W_SENDFAIL 22       // 失败图标宽度
#define W_MAX (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)           // 文本最大宽度
#define W_MAX_IMAGE (100 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度
#define W_MAX_POSITION (200 + [Slacker getXMarginFrom320ToNowScreen] * 2)  // ‘位置’截图最大宽度

#define X_BUBBLE_MARGIN_BIGGER  5.0        // 真实的图片在气泡内部的较大一边的 MARGIN
#define X_BUBBLE_MARGIN_SMALLER 2.0        // 真实的图片在气泡内部的较小一边的 MARGIN
#define Y_BUBBLE_MARGIN         2.0        // 真实的图片在气泡内部上下边的 MARGIN
#define H_BUBBLE 42         // 气泡默认高度，和宽度

#define CHAT_BUBBLE @"chat_right_bubble" // 气泡

#define CHAT_SENDFAIL @"chat_sendFail" // 发送失败

@interface ChatRightVideoTableViewCell ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *videoPlayer;

@end

@implementation ChatRightVideoTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier HeadIcon:(NSString *)imgUrl Target:(id)target ActionTap:(SEL)actionTap ActionLong:(SEL)actionLong ActionFail:(SEL)actionFail ActionHead:(SEL)actionHead
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // 头像
        _imgViewHeadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(IOS_SCREEN_WIDTH - MARGE - W_HEADICON, MARGE_TOP, W_HEADICON, W_HEADICON)];
        [_imgViewHeadIcon sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:IMG_PLACEHOLDER_HEAD];
        [_imgViewHeadIcon.layer setCornerRadius:W_HEADICON / 2];
        [_imgViewHeadIcon.layer setMasksToBounds:YES];
        [_imgViewHeadIcon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionHead];
        [_imgViewHeadIcon addGestureRecognizer:tapGesture];
        [self addSubview:_imgViewHeadIcon];
        
        // 背景气泡
        _imgViewBubble = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
        img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
        [_imgViewBubble setImage:img];
        [self addSubview:_imgViewBubble];
        
        _imgViewImage = [[UIImageView alloc] init];
        [_imgViewImage.layer setCornerRadius:2];
        [_imgViewImage.layer setMasksToBounds:YES];
        [_imgViewBubble addSubview:_imgViewImage];
        
        // 为图片添加手势
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionTap];
        [_imgViewBubble setUserInteractionEnabled:YES];
        [_imgViewBubble addGestureRecognizer:tapGesture];
        
        // 给气泡添加长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:actionLong];
        [_imgViewBubble addGestureRecognizer:longGesture];
        
        // 旋转图标
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_loadingIndicator setHidesWhenStopped:YES];
        [self addSubview:_loadingIndicator];
        
        // 失败图案
        _imgViewFailed = [[UIImageView alloc] init];
        [_imgViewFailed setImage:[UIImage imageNamed:CHAT_SENDFAIL]];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionFail];
        [_imgViewFailed setUserInteractionEnabled:YES];
        [_imgViewFailed addGestureRecognizer:gest];
        [self addSubview:_imgViewFailed];
        
        // 指示器
        _viewIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_viewIndicator setHidesWhenStopped:YES];
        [self.contentView addSubview:_viewIndicator];
        
        __weak typeof(self) weakSelf = self; // prevent memory cycle
        NSNotificationCenter *noteCenter = [NSNotificationCenter defaultCenter];
        [noteCenter addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                object:nil // any object can send
                                 queue:nil // the queue of the sending
                            usingBlock:^(NSNotification *note) {
                                // holding a pointer to avPlayer to reuse it
                                [weakSelf.videoPlayer seekToTime:kCMTimeZero];
                                [weakSelf.videoPlayer play];
                            }];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:AVPlayerItemDidPlayToEndTimeNotification];
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

#pragma mark - OverWrite
- (void)setTag:(NSInteger)tag
{
    [_imgViewBubble setTag:tag];
    [_imgViewFailed setTag:tag];
    [_imgViewHeadIcon setTag:tag];
}

#pragma mark -- Private Method

// 发送loading
- (void)showSending
{
    [_imgViewFailed setHidden:YES];
    [_loadingIndicator setFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LOADING - (_loadingIndicator.frame.size.width), (_imgViewBubble.frame.size.height - _loadingIndicator.frame.size.height) / 2 + MARGE_TOP, _loadingIndicator.frame.size.width, _loadingIndicator.frame.size.height)];
    [_loadingIndicator startAnimating];
}

// 发送成功，停止转动
- (void)showSendSuccess
{
    [_imgViewFailed setHidden:YES];
    [_loadingIndicator stopAnimating];
}

// 发送失败
- (void)showSendFail
{
    [_loadingIndicator stopAnimating];
    [_imgViewFailed setHidden:NO];
    [_imgViewFailed setFrame:CGRectMake(_imgViewBubble.frame.origin.x - INTERVAL_LOADING - W_SENDFAIL, (_imgViewBubble.frame.size.height - W_SENDFAIL) / 2 + MARGE_TOP, W_SENDFAIL, W_SENDFAIL)];
}

#pragma mark -- Interface Method
// 设置状态
- (void)showStatus:(Msg_status)status
{
    switch (status)
    {
        case status_send_success:
            [self showSendSuccess];
            break;
            
        case status_sending:
        case status_send_waiting:
            [self showSending];
            break;
            
        case status_send_failed:
            [self showSendFail];
            break;
            
        default:
            break;
    }
}

- (void)showReceiveImageMessage:(NSString *)imageUrl Tag:(NSInteger)tag
{
    [_imgViewBubble setTag:tag];
    BOOL isShowLoading = NO;
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl];
    if (image == nil)
    {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
        if (image == nil)
        {
            // 显示默认图
            image = IMG_PLACEHOLDER_LOADING;
            isShowLoading = YES;
            
            __block ChatRightVideoTableViewCell *blockSelf = self;
            [_imgViewImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMG_PLACEHOLDER_LOADING completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [blockSelf performSelector:@selector(sendNotify) withObject:nil afterDelay:1.0];
                
            }];
        }
    }
    CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
    CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
    
    CGFloat W_img = MIN(W_MAX_IMAGE, imgWidthAddMargin);
    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
    
    // 气泡图片
    CGFloat W_bubbleImg = MAX(W_img, H_BUBBLE);
    CGFloat H_bubbleImg = MAX(H_img, H_BUBBLE);
    
    CGFloat X_marge = 0;
    CGFloat Y_marge = 0;
    if (W_img < H_BUBBLE)
    {
        X_marge = (H_BUBBLE - W_img) * 0.5;
    }
    if (H_img < H_BUBBLE)
    {
        Y_marge = (H_BUBBLE - H_img) * 0.5;
    }
    
    // 气泡图片
    [_imgViewBubble setFrame:CGRectMake(_imgViewHeadIcon.frame.origin.x - INTERVAL - W_bubbleImg, MARGE_TOP, W_bubbleImg, H_bubbleImg)];
    [_imgViewImage setFrame:CGRectMake(X_BUBBLE_MARGIN_SMALLER + X_marge, Y_BUBBLE_MARGIN + Y_marge, W_img - X_BUBBLE_MARGIN_BIGGER - X_BUBBLE_MARGIN_SMALLER, H_img - 2.0 * Y_BUBBLE_MARGIN)];
    [_imgViewImage setImage:image];

    
    // 指示器位置
    [_viewIndicator setCenter:_imgViewBubble.center];
    
    [self setImageLoading:isShowLoading];
}

- (void)showSendImageMessageBaseModel:(MessageBaseModel *)model Tag:(NSInteger)tag
{
    [_imgViewBubble setTag:tag];
    
    NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeThumbnailUrl];
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
    CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
    
    CGFloat W_img = MIN(W_MAX_IMAGE, imgWidthAddMargin);
    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
    
    // 气泡图片
    [_imgViewBubble setFrame:CGRectMake(_imgViewHeadIcon.frame.origin.x - INTERVAL - W_img, MARGE_TOP, W_img, H_img)];
    [_imgViewImage setFrame:CGRectMake(X_BUBBLE_MARGIN_SMALLER, Y_BUBBLE_MARGIN, W_img - X_BUBBLE_MARGIN_BIGGER - X_BUBBLE_MARGIN_SMALLER, H_img - 2.0 * Y_BUBBLE_MARGIN)];
    [_imgViewImage setImage:image];
    
    fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl];
    
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:fullPath];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    self.playerLayer.frame = _imgViewImage.layer.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.videoPlayer = player;
    
    [_imgViewImage.layer addSublayer:self.playerLayer];
    [player play];
}

/** 加载指示器关闭开启
 */
- (void)setImageLoading:(BOOL)loading
{
    if (loading)
    {
        [_viewIndicator startAnimating];
    }
    else
    {
        [_viewIndicator stopAnimating];
    }
}

#pragma mark - Private Method

- (void)sendNotify
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:MTImageDidFinishedLoadNotification  object:nil];
}



@end

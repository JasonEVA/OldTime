//
//  ChatLeftVideoTableViewCell.m
//  PalmDoctorPT
//
//  Created by Lars Chen on 15/7/7.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "ChatLeftVideoTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <UIImageView+WebCache.h>

#define MARGE 12            // 头像距边界的距离
#define MARGE_TOP 8         // 头像距顶部边界的距离

#define INTERVAL 7          // 头像与图片间隔
#define W_HEADICON 42       // 头像宽度
#define W_MAX   (185 + [Slacker getXMarginFrom320ToNowScreen] * 2)         // 图片最大宽度
#define W_MAX_IMAGE (100 + [Slacker getXMarginFrom320ToNowScreen] * 2)     // 照片最大宽度
#define W_MAX_POSITION (200 + [Slacker getXMarginFrom320ToNowScreen] * 2)  // ‘位置’截图最大宽度
#define H_NAME 15           // 姓名高度

#define X_BUBBLE_MARGIN_BIGGER  5.0        // 真实的图片在气泡内部的较大一边的 MARGIN
#define X_BUBBLE_MARGIN_SMALLER 2.0        // 真实的图片在气泡内部的较小一边的 MARGIN
#define Y_BUBBLE_MARGIN         2.0        // 真实的图片在气泡内部上下边的 MARGIN
#define H_BUBBLE 42         // 气泡默认高度，和宽度

#define CHAT_BUBBLE @"chat_left_bubble" // 气泡

@implementation ChatLeftVideoTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier Target:(id)target Action:(SEL)action ActionHead:(SEL)actionHead ActionLong:(SEL)actionLong
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        // 头像
        _imgViewHeadIcon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGE, MARGE_TOP, W_HEADICON, W_HEADICON)];
        [_imgViewHeadIcon.layer setCornerRadius:W_HEADICON / 2];
        [_imgViewHeadIcon.layer setMasksToBounds:YES];
        [_imgViewHeadIcon setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:actionHead];
        [_imgViewHeadIcon addGestureRecognizer:tapGesture];
        [self.contentView addSubview:_imgViewHeadIcon];
        
        // 背景气泡
        _imgViewBubble = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:CHAT_BUBBLE];
        img = [img stretchableImageWithLeftCapWidth:img.size.width / 2 topCapHeight:img.size.height * 0.8];
        [_imgViewBubble setImage:img];
        [self.contentView addSubview:_imgViewBubble];
        
        // 图片
        _imgViewImage = [[UIImageView alloc] init];
        [_imgViewImage.layer setCornerRadius:2];
        [_imgViewImage.layer setMasksToBounds:YES];
        [_imgViewBubble addSubview:_imgViewImage];
        
        // 为气泡添加手势
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [_imgViewBubble setUserInteractionEnabled:YES];
        [_imgViewBubble addGestureRecognizer:tapGesture];
        
        // 给气泡添加长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:actionLong];
        [_imgViewBubble addGestureRecognizer:longGesture];
        
        // 姓名
        _lbName = [[UILabel alloc] initWithFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + 10, MARGE_TOP, W_MAX, H_NAME)];
        [_lbName setFont:[UIFont systemFontOfSize:11]];
        [_lbName setTextColor:[UIColor grayColor]];
        [_lbName setBackgroundColor:[UIColor clearColor]];
        
        // 指示器
        _viewIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_viewIndicator setHidesWhenStopped:YES];
        [self.contentView addSubview:_viewIndicator];
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

#pragma mark -- Interface Method
- (void)showImageMessage:(NSString *)imageUrl Tag:(NSInteger)tag
{
    [_imgViewBubble setTag:tag];
    [_imgViewHeadIcon setTag:tag];
    
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
            
            __block ChatLeftVideoTableViewCell *blockSelf = self;
            [_imgViewImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMG_PLACEHOLDER_LOADING completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [blockSelf performSelector:@selector(sendNotify) withObject:nil afterDelay:1.0];
                
            }];
        }
    }
    CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
    CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
    
    CGFloat W_img = MIN(W_MAX_IMAGE, imgWidthAddMargin);
    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
    
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
    [_imgViewBubble setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + INTERVAL, MARGE_TOP, W_bubbleImg, H_bubbleImg)];
    [_imgViewImage setFrame:CGRectMake(X_BUBBLE_MARGIN_BIGGER + X_marge, Y_BUBBLE_MARGIN + Y_marge, W_img - X_BUBBLE_MARGIN_BIGGER - X_BUBBLE_MARGIN_SMALLER, H_img - 2.0 * Y_BUBBLE_MARGIN)];
    [_imgViewImage setImage:image];
    
    // 指示器位置
    [_viewIndicator setCenter:_imgViewBubble.center];
    
    [self setImageLoading:isShowLoading];
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

// 显示位置截图
- (void)showPositionMessage:(NSString *)imageUrl Tag:(NSInteger)tag
{
    [_imgViewBubble setTag:tag];
    [_imgViewHeadIcon setTag:tag];
    
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
            
            //            __block ChatLeftImageTableViewCell *blockSelf = self;
            [_imgViewImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMG_PLACEHOLDER_LOADING completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //                [[NSNotificationCenter defaultCenter] postNotificationName:MTImageDidFinishedLoadNotification  object:nil];
                return;
                
            }];
            //            [_imgViewImage setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMG_PLACEHOLDER_LOADING completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
            //             {
            ////                 if (image != nil)
            ////                 {
            ////                     CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
            ////                     CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
            ////
            ////                     CGFloat W_img = MIN(W_MAX_POSITION, imgWidthAddMargin);
            ////                     CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
            ////
            ////                     // 气泡图片
            ////                     [blockSelf->_imgViewBubble setFrame:CGRectMake([Slacker getValueWithFrame:blockSelf->_imgViewHeadIcon.frame WithX:YES] + INTERVAL, MARGE_TOP, W_img, H_img)];
            ////                     [blockSelf->_imgViewImage setFrame:CGRectMake(X_BUBBLE_MARGIN_BIGGER, Y_BUBBLE_MARGIN, W_img - X_BUBBLE_MARGIN_BIGGER - X_BUBBLE_MARGIN_SMALLER, H_img - 2.0 * Y_BUBBLE_MARGIN)];
            ////                     [blockSelf->_imgViewImage setImage:image];
            ////                     // 指示器位置
            ////                     [blockSelf->_viewIndicator setCenter:blockSelf->_imgViewImage.center];
            ////                 }
            //
            //                 // 发送消息
            //                 [[NSNotificationCenter defaultCenter] postNotificationName:MTImageDidFinishedLoadNotification  object:nil];
            //                 return;
            //             }];
        }
    }
    CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
    CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
    
    CGFloat W_img = MIN(W_MAX_POSITION, imgWidthAddMargin);
    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
    
    // 气泡图片
    [_imgViewBubble setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + INTERVAL, MARGE_TOP, W_img, H_img)];
    [_imgViewImage setFrame:CGRectMake(X_BUBBLE_MARGIN_BIGGER, Y_BUBBLE_MARGIN, W_img - X_BUBBLE_MARGIN_BIGGER - X_BUBBLE_MARGIN_SMALLER, H_img - 2.0 * Y_BUBBLE_MARGIN)];
    [_imgViewImage setImage:image];
    // 指示器位置
    [_viewIndicator setCenter:_imgViewImage.center];
    
    [self setImageLoading:isShowLoading];
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
        [_imgViewBubble setCenter:CGPointMake(_imgViewBubble.center.x, _imgViewBubble.center.y + H_NAME)];
        
    }
    else
    {
        [_lbName removeFromSuperview];
        [_imgViewBubble setFrame:CGRectMake([Slacker getValueWithFrame:_imgViewHeadIcon.frame WithX:YES] + INTERVAL, MARGE_TOP, _imgViewBubble.frame.size.width, _imgViewBubble.frame.size.height)];
    }
}

#pragma mark - Private Method

- (void)sendNotify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTImageDidFinishedLoadNotification  object:nil];
}


@end

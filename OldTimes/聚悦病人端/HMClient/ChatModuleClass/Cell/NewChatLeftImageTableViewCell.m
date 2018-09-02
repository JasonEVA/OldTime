//
//  NewChatLeftImageTableViewController.m
//  launcher
//
//  Created by Lars Chen on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "NewChatLeftImageTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <UIImageView+WebCache.h>
//#import "NSString+Manager.h"
#import <Masonry.h>
#import "MessageBubblePhotoImageView.h"
//#import "UnifiedUserInfoManager.h"
#import <MJExtension/MJExtension.h>
#import "UIImage+EX.h"
#import "UIColor+Hex.h"
#import "ChatIMConfigure.h"

#define MARGE 20            // 头像距边界的距离
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

#define CHAT_BUBBLE @"chat_left_bubble" // 气泡

#define PLACEHOLDEWIDTH    IMG_PLACEHOLDER_LOADING.size.width       //占位图宽度
#define PLACEHOLDEHEIGHT    IMG_PLACEHOLDER_LOADING.size.height       //占位图高度

@interface NewChatLeftImageTableViewCell ()

@property (nonatomic, strong) UIActivityIndicatorView *viewIndicator;    // 旋转指示器
@property (nonatomic, strong) MessageBubblePhotoImageView *imgViewImage;    // 图片
@property (nonatomic, strong) UIImageView * placeholderImg;

@property (nonatomic, strong) MASConstraint *constraintImageWidth;
@property (nonatomic, strong) MASConstraint *constraintImageHeight;

@property (nonatomic, strong) MessageBaseModel *baseModel;

@end

@implementation NewChatLeftImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgViewBubble.image = nil;
        [self.contentView addSubview:self.imgViewImage];
        [self.contentView addSubview:self.placeholderImg];
        [self.contentView addSubview:self.viewIndicator];
        [self.imgViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imgViewBubble);
            self.constraintImageWidth = make.width.equalTo(@W_MAX_IMAGE);
            self.constraintImageHeight = make.height.equalTo(@1).priorityHigh();
        }];
        [self.placeholderImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.imgViewImage);
        }];
        [self.viewIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imgViewBubble);
        }];
    }
    
    return self;
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
#pragma mark - Interface Method
- (void)showSendImageMessageBaseModel:(MessageBaseModel *)baseModel {
    self.placeholderImg.image = nil;
    NSString *fullPath = [NSString stringWithFormat:@"%@%@",im_IP_http,baseModel.attachModel.thumbnail];
    
    CGSize imageSize = CGSizeMake(baseModel.attachModel.thumbnailWidth, baseModel.attachModel.thumbnailHeight);
    
    SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
    NSString * string = [NSString stringWithFormat:@"AppName=%@;UserName=%@",im_appName,[MessageManager getUserID]];
    [manager setValue:string forHTTPHeaderField:@"Cookie"];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fullPath];
    
    if (image) {
        //        imageSize = image.size;
    } else {
        // 图片下载过程中需要loding
        [self setImageLoading:YES];
        __weak typeof(self) weakSelf = self;
        
        [_imgViewImage.imgViewPhoto sd_setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:IMG_PLACEHOLDER_LOADING options:([self IsNeedCookieWithImageURL:fullPath] ? SDWebImageHandleCookies : 0) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *imageURLString = [imageURL absoluteString];
            if (![fullPath isEqualToString:imageURLString]) {
                return;
            }
            
            if (image) {
                if (imageSize.height == 0) {
                    strongSelf.baseModel = baseModel;
                    [strongSelf performSelector:@selector(sendNotify) withObject:nil afterDelay:1.0];
                } else {
                    
                    //                    // 设置图片
                    //                    CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
                    //                    CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
                    //
                    //                    CGFloat W_img = MIN(W_MAX_IMAGE, imgWidthAddMargin);
                    //                    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
                    //
                    //                    // 气泡图片
                    //                    if (W_img < PLACEHOLDEWIDTH)
                    //                    {
                    //                        W_img = PLACEHOLDEWIDTH;
                    //                    }
                    //                    strongSelf.constraintImageWidth.offset = W_img;
                    //                    strongSelf.constraintImageHeight.offset = H_img;
                    //
                    //                    [strongSelf setNeedsUpdateConstraints];
                    //                    [strongSelf updateConstraintsIfNeeded];
                    [_imgViewImage.imgViewPhoto setImage:image];
                    [_imgViewImage setNeedsDisplay];
                }
                
                strongSelf.placeholderImg.image = nil;
            }
            // 下载结束,结束loding,(不管他是否成功)
            [strongSelf setImageLoading:NO];
        }];
    }
    
    self.placeholderImg.image = image ? nil : IMG_PLACEHOLDER_LOADING;
    
    if (imageSize.height == 0) {
        UIImage *placeholderImage = IMG_PLACEHOLDER_LOADING;
        imageSize.width  = placeholderImage.size.width;
        imageSize.height = placeholderImage.size.height;
    }
    
    CGFloat imgWidthAddMargin = imageSize.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
    CGFloat imgHeightAddMargin = imageSize.height + Y_BUBBLE_MARGIN * 2.0;
    
    CGFloat W_img = MIN(W_MAX_IMAGE, imgWidthAddMargin);
    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
    
    // 气泡图片
    if (W_img < PLACEHOLDEWIDTH)
    {
        W_img = PLACEHOLDEWIDTH;
    }
    self.constraintImageWidth.offset = MAX(W_img, PLACEHOLDEWIDTH + 20);  //保证占位图显示完整
    self.constraintImageHeight.offset = MAX(PLACEHOLDEHEIGHT + 20, H_img) ;
    UIImage * img = IMG_PLACEHOLDER_LOADING;
    if (!image && W_img >= img.size.width && H_img > img.size.height) {
        // 有宽高,但是没有图片
        [self.imgViewImage.imgViewPhoto setImage:[UIImage imageColor:ChatBubbleLeftConfigShare.textBackgroundColor size:CGSizeMake(1, 1) cornerRadius:0]];
    }
    
    !image ?:[self.imgViewImage.imgViewPhoto setImage:image];
    [self.imgViewImage setNeedsDisplay];
}

- (BOOL)IsNeedCookieWithImageURL:(NSString *)url {
    return ![url hasSuffix:@"jpg"] && ![url hasSuffix:@"png"];
}

- (UIImage*)createMaskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    UIImage *newImag = [UIImage imageWithCGImage:masked];
    CGImageRelease(mask);
    CGImageRelease(masked);
    return newImag;
}

// 显示位置截图
- (void)showPositionMessage:(NSString *)imageUrl Tag:(NSInteger)tag
{
    [self.imgViewBubble setTag:tag];
    
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
            [_imgViewImage.imgViewPhoto sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:IMG_PLACEHOLDER_LOADING completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_IMAGE_FINISH_LOADED  object:nil];
                return;
                
            }];
            
        }
    }
    CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
    CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
    
    CGFloat W_img = MIN(W_MAX_POSITION, imgWidthAddMargin);
    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
    
    // 气泡图片
    self.constraintImageWidth.offset = W_img;
    self.constraintImageHeight.offset = H_img;
    
    [self setImageLoading:isShowLoading];
}

- (MessageBubblePhotoImageView *)imgViewImage
{
    if (!_imgViewImage)
    {
        _imgViewImage = [[MessageBubblePhotoImageView alloc] initWithFrame:CGRectZero];
        _imgViewImage.type = MessageTypeReceiving;
        //        [_imgViewImage.layer setCornerRadius:2];
        //        [_imgViewImage.layer setMasksToBounds:YES];
        [_imgViewImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_imgViewImage setContentMode:UIViewContentModeScaleAspectFit];
        [_imgViewImage setBackgroundColor:[UIColor clearColor]];
        _imgViewImage.userInteractionEnabled = NO;
    }
    
    return _imgViewImage;
}

- (UIActivityIndicatorView *)viewIndicator
{
    if (!_viewIndicator)
    {
        // 指示器
        _viewIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_viewIndicator setHidesWhenStopped:YES];
    }
    
    return _viewIndicator;
}

- (UIImageView *)placeholderImg
{
    if (!_placeholderImg) {
        _placeholderImg = [[UIImageView alloc] init];
    }
    return _placeholderImg;
}

#pragma mark - Private Method

- (void)sendNotify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notify_image_finish_loaded  object:self.baseModel];
}

@end

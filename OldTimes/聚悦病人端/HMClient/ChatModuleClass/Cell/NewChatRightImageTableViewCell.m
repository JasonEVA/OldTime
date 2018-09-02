 //
//  NewChatRightImageTableViewCell.m
//  launcher
//
//  Created by Lars Chen on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "NewChatRightImageTableViewCell.h"
#import "Slacker.h"
#import "MyDefine.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "MessageBubblePhotoImageView.h"
#import "SDWebImageDownloader.h"
//#import "Category.h"
#import "ChatIMConfigure.h"
#import "UIImage+EX.h"
#import "ChatBaseTableViewCell+BubbleStyleEdit.h"

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
#define PLACEHOLDEWIDTH    IMG_PLACEHOLDER_LOADING.size.width       //占位图宽度
#define PLACEHOLDEHEIGHT    IMG_PLACEHOLDER_LOADING.size.height       //占位图高度


@interface NewChatRightImageTableViewCell ()

@property (nonatomic, strong) MessageBubblePhotoImageView *imgViewImage;    // 图片
@property (nonatomic, strong) UIActivityIndicatorView *viewIndicator;    // 旋转指示器
@property (nonatomic, strong) UIImageView * placeholderImg;

@property (nonatomic, strong) UIProgressView *uploadProgressView;

@property (nonatomic, strong) MASConstraint *constraintBubbleWidth;
@property (nonatomic, strong) MASConstraint *constraintBubbleHeight;

@property (nonatomic, strong) MessageBaseModel *baseModel;

@end

@implementation NewChatRightImageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgViewBubble.image = nil;
        [self.contentView addSubview:self.imgViewImage];
        [self.contentView addSubview:self.placeholderImg];
        [self.contentView addSubview:self.viewIndicator];
        [self.contentView addSubview:self.uploadProgressView];

        [self.viewIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imgViewBubble);
        }];
        
        [self.imgViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.imgViewBubble);
            self.constraintBubbleWidth = make.width.equalTo(@W_MAX_IMAGE);
            self.constraintBubbleHeight = make.height.equalTo(@1);
        }];
        [self.placeholderImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imgViewImage);
        }];
        [self.uploadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgViewImage).offset(10);
            make.right.equalTo(self.imgViewImage).offset(-10);
            make.top.equalTo(self.imgViewImage.mas_bottom).offset(10);
            make.height.equalTo(@2);
        }];
    }
    
    return self;
}

- (void)showSendImageMessage:(MessageBaseModel *)baseModel
{
    self.placeholderImg.image = nil;
    NSString *fullPath;
    UIImage *image;
    
    self.baseModel = baseModel;
    
    CGSize imageSize = CGSizeMake(baseModel.attachModel.thumbnailWidth, baseModel.attachModel.thumbnailHeight);
    
    [self setImageLoading:NO];
    // 可能是同步下来的 同步下来的统一存在Content里面
    //    if (baseModel._nativeThumbnailUrl.length == 0)
    //    {
    fullPath = [NSString stringWithFormat:@"%@%@",im_IP_http,baseModel.attachModel.thumbnail];
    image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fullPath];
    
    if (!image) {
        [self setImageLoading:YES];
        
        self.placeholderImg.image = IMG_PLACEHOLDER_LOADING;
        [self.placeholderImg setNeedsDisplay];
        
        SDWebImageDownloader *manager = [SDWebImageDownloader sharedDownloader];
        NSString * string = [NSString stringWithFormat:@"AppName=%@;UserName=%@",im_appName,[MessageManager getUserID]];
        [manager setValue:string forHTTPHeaderField:@"Cookie"];
        __weak typeof(self) weakSelf = self;
        // [[SDImageCache sharedImageCache] setShouldDecompressImages:NO];
        // [[SDWebImageDownloader sharedDownloader] setShouldDecompressImages:NO];
        [_imgViewImage.imgViewPhoto sd_setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:IMG_PLACEHOLDER_LOADING options:([self IsNeedCookieWithImageURL:fullPath] ? SDWebImageHandleCookies : 0) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *imageURLString = [imageURL absoluteString];
            if (![imageURLString isEqualToString:fullPath]) {
                return;
            }
            
            if (image) {
                if (imageSize.height == 0) {
                    // 不知道图片大小，需重新设置
                    strongSelf.baseModel = baseModel;
                    [strongSelf performSelector:@selector(sendNotify) withObject:nil afterDelay:1.0];
                } else {
                    // 设置图片
                    //                        CGFloat imgWidthAddMargin  = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
                    //                        CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
                    //
                    //                        CGFloat W_img = MIN(W_MAX_IMAGE, imgWidthAddMargin);
                    //                        CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
                    //
                    //                        // 气泡图片
                    //                        if (W_img < PLACEHOLDEWIDTH)
                    //                        {
                    //                            W_img = PLACEHOLDEWIDTH;
                    //                        }
                    //                        strongSelf.constraintBubbleWidth.offset = W_img;
                    //                        strongSelf.constraintBubbleHeight.offset = H_img;
                    //                        [strongSelf setNeedsUpdateConstraints];
                    //                        [strongSelf updateConstraintsIfNeeded];
                    [_imgViewImage.imgViewPhoto setImage:image];
                    [_imgViewImage setNeedsDisplay];
                }
                
                strongSelf.placeholderImg.image = nil;
            }
            
            [strongSelf setImageLoading:NO];
        }];
    }
    
    self.placeholderImg.image = image ? nil : IMG_PLACEHOLDER_LOADING;
    //    }
    //    else
    //    {
    //        fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:baseModel._nativeThumbnailUrl];
    //        image = [UIImage imageWithContentsOfFile:fullPath];
    //    }
    
    //    imageSize = image ? image.size : CGSizeMake(baseModel.attachModel.thumbnailWidth, baseModel.attachModel.thumbnailHeight);
    
    if (imageSize.height == 0) {
        UIImage *placeholderImage = IMG_PLACEHOLDER_LOADING;
        imageSize.width  = placeholderImage.size.width;
        imageSize.height = placeholderImage.size.height;
    }
    
    CGFloat imgWidthAddMargin  = imageSize.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
    CGFloat imgHeightAddMargin = imageSize.height + Y_BUBBLE_MARGIN * 2.0;
    
    CGFloat W_img = MIN(W_MAX_IMAGE, imgWidthAddMargin);
    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
    
    // 气泡图片
    if (W_img < PLACEHOLDEWIDTH)
    {
        W_img = PLACEHOLDEWIDTH;
    }
    
    self.constraintBubbleWidth.offset = MAX(W_img, PLACEHOLDEWIDTH + 20);  //保证占位图显示完整
    self.constraintBubbleHeight.offset = MAX(PLACEHOLDEHEIGHT + 20, H_img) ;
    UIImage * img = IMG_PLACEHOLDER_LOADING;
    if (!image && W_img >= img.size.width && H_img > img.size.height) {
        // 有宽高,但是没有图片
        [self.imgViewImage.imgViewPhoto setImage:[UIImage at_imageWithColor:[UIColor colorWithHexString:@"dfdfdf"] size:CGSizeMake(1, 1)]];
    }
    
    !image ?: [_imgViewImage.imgViewPhoto setImage:image];
    [_imgViewImage setNeedsDisplay];
}

- (BOOL)IsNeedCookieWithImageURL:(NSString *)url {
    return ![url hasSuffix:@"jpg"] && ![url hasSuffix:@"png"];
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
- (void)showPositionMessage:(UIImage *)image Tag:(NSInteger)tag
{
    [self.imgViewBubble setTag:tag];
    
    CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
    CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
    
    CGFloat W_img = MIN(W_MAX_POSITION, imgWidthAddMargin);
    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
    
    // 气泡图片
    self.constraintBubbleWidth.offset = W_img;
    self.constraintBubbleHeight.offset = H_img;
}

- (void)showStatus:(Msg_status)status progress:(NSNumber *)progress {
    [self showImageUploadStatus:status];
    
    double percentage = [progress doubleValue];
    if (!progress) {
        // 已经上传成功
        percentage = 1;
    }
    
    self.uploadProgressView.hidden = NO;
    switch (status) {
        case status_send_success:
        case status_send_failed:
            self.uploadProgressView.hidden = YES;
            break;
        case status_send_waiting:
        case status_sending:
            [self.uploadProgressView setProgress:percentage animated:self.uploadProgressView.progress < percentage];
            break;
        default:
            break;
    }
}

#pragma mark - Initializer
- (MessageBubblePhotoImageView *)imgViewImage
{
    if (!_imgViewImage)
    {
        _imgViewImage = [[MessageBubblePhotoImageView alloc] init];
        _imgViewImage.type = MessageTypeSending;
        [_imgViewImage.layer setCornerRadius:2];
        [_imgViewImage.layer setMasksToBounds:YES];
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

- (UIProgressView *)uploadProgressView {
    if (!_uploadProgressView) {
        _uploadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _uploadProgressView.progressTintColor = [UIColor mainThemeColor];
        _uploadProgressView.trackTintColor = [UIColor colorWithHexString:@"999999"];
    }
    return _uploadProgressView;
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

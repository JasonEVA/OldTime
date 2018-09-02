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
#import "NSString+Manager.h"
#import <Masonry.h>
#import "MessageBubblePhotoImageView.h"
#import "UnifiedUserInfoManager.h"
#import <MJExtension/MJExtension.h>
#import "UIImage+Manager.h"
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
#define INCREAMENT 25       // 增量
#define H_MIN   80          // 最小高度
#define CHAT_BUBBLE @"chat_left_bubble" // 气泡
#define H_GROUPNICK 10      // 群成员昵称偏移量

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
        [self.wz_contentView addSubview:self.imgViewImage];
        [self.wz_contentView addSubview:self.placeholderImg];
        [self.wz_contentView addSubview:self.viewIndicator];
		
        [self.imgViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.imgViewBubble);
			make.top.equalTo(self.imgViewBubble).offset(-8);
            self.constraintImageWidth = make.width.equalTo(@W_MAX_IMAGE);
			self.constraintImageHeight = make.height.equalTo(@1).priorityHigh();
        }];
        [self.placeholderImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.imgViewImage);
            make.top.equalTo(self.imgViewImage).offset(10);
            make.bottom.equalTo(self.imgViewImage).offset(-10);
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
    NSString * string = [NSString stringWithFormat:@"AppName=%@;UserName=%@", im_appName,[UnifiedUserInfoManager share].userShowID];
    [manager setValue:string forHTTPHeaderField:@"Cookie"];

    //缓存中去取
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fullPath];
    
    if (image) {
        imageSize = image.size;
    } else {
        // 图片下载过程中需要loding
        [self setImageLoading:YES];
        [_imgViewImage.imgViewPhoto sd_setImageWithURL:[NSURL URLWithString:fullPath] placeholderImage:IMG_PLACEHOLDER_LOADING options:([self IsNeedCookieWithImageURL:fullPath] ? SDWebImageHandleCookies : 0) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            NSString *imageURLString = [imageURL absoluteString];
            if (![fullPath isEqualToString:imageURLString]) {
                return;
            }
            
            if (image) {
                if (imageSize.height == 0) {
                    self.baseModel = baseModel;
                    [self performSelector:@selector(sendNotify) withObject:nil afterDelay:1.0];
                } else {

                    // 设置图片
                    CGFloat imgWidthAddMargin = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;
                    CGFloat imgHeightAddMargin = image.size.height + Y_BUBBLE_MARGIN * 2.0;
                    
                    CGFloat W_img = MIN(W_MAX_IMAGE, imgWidthAddMargin);
                    CGFloat H_img = (W_img / imgWidthAddMargin) * imgHeightAddMargin;
                    
                    // 气泡图片
                    if (W_img < 40)
                    {
                        W_img = 40;
                    }
                    self.constraintImageWidth.offset = W_img;
                    self.constraintImageHeight.offset = H_img;
                    
                    [self setNeedsUpdateConstraints];
                    [self updateConstraintsIfNeeded];
                    [_imgViewImage.imgViewPhoto setImage:image];
                    [_imgViewImage setNeedsDisplay];
                }
                self.placeholderImg.image = nil;
            }
            else
            {
                [self.placeholderImg setImage:IMG_PLACEHOLDER_EXPIRED];
                self.imgViewImage.imgViewPhoto = nil;
                [self.placeholderImg setNeedsDisplay];
            }
            // 下载结束,结束loding,(不管他是否成功)
            [self setImageLoading:NO];
        }];
    }
    
    /***没有下到时用于显示效果 ***/
    
    
    //如果显示loading时展示 加载效果
    if (self.viewIndicator.isAnimating) {
        self.placeholderImg.image = image ? nil : IMG_PLACEHOLDER_LOADING;
    }
    
    //计算图片尺寸
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
    if (W_img < 40)
    {
        W_img = 40;
    }
    self.constraintImageWidth.offset = W_img;
    self.constraintImageHeight.offset = H_img;
	[self.constraintImageHeight activate];
	
    
    //在没有获取到图片的时候显示
    UIImage * img = IMG_PLACEHOLDER_LOADING;
    if (!image && W_img >= img.size.width && H_img > img.size.height) {
        // 有宽高,但是没有图片
        [self.imgViewImage.imgViewPhoto setImage:[UIImage mtc_imageColor:ChatBubbleLeftConfigShare.textBackgroundColor]];
		if (!baseModel.attachModel.thumbnail) {
			self.constraintImageWidth.mas_equalTo(W_MAX_IMAGE);
			[self.constraintImageHeight deactivate];
		}
		
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
    return [UIImage imageWithCGImage:masked];
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
                //                [[NSNotificationCenter defaultCenter] postNotificationName:MTImageDidFinishedLoadNotification  object:nil];
                if (!image) {
//                    [_imgViewImage.imgViewPhoto setImage:[UIImage imageNamed:@"expried"]];
                }
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

+ (CGFloat)cellHeightWithContent:(id)content needShowNickName:(BOOL)needShow {
	if (![content isKindOfClass:[MessageBaseModel class]]) {
		return 0;
	}
	
	MessageBaseModel *model = (MessageBaseModel *)content;
	NSString *imageUrl;
	UIImage *image = nil;
	if (model._markFromReceive) {
		imageUrl = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
	} else {
		// 区分是web端同步下来的还是本地发送的
		if (model._nativeThumbnailUrl.length == 0)
		{
			imageUrl = [NSString stringWithFormat:@"%@%@",im_IP_http,model.attachModel.thumbnail];
		}
		else
		{
			NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeThumbnailUrl];
			image = [UIImage imageWithContentsOfFile:fullPath];
		}
	}
	
	// 区分收发（收是NSString，发送是UIImage）
	if (!image) {
		image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
	}
	
	CGFloat imageWidth  = model.attachModel.thumbnailWidth;
	CGFloat imageHeight = model.attachModel.thumbnailHeight;
	
	if (!image) {
		if (model.attachModel.thumbnailHeight == 0) {
			return W_MAX_IMAGE;
		}
	}
	else {
		imageWidth  = image.size.width + X_BUBBLE_MARGIN_BIGGER + X_BUBBLE_MARGIN_SMALLER;;
		imageHeight = image.size.height + Y_BUBBLE_MARGIN * 2.0;
	}
	
	CGFloat showWidth = MIN(W_MAX_IMAGE, imageWidth);
	CGFloat showHeight = (showWidth / imageWidth) * imageHeight;
	CGFloat height = MAX(showHeight + INCREAMENT + 8, H_MIN) + (needShow ? H_GROUPNICK : 0);
	

	
	return height;
}

- (MessageBubblePhotoImageView *)imgViewImage
{
    if (!_imgViewImage)
    {
        _imgViewImage = [[MessageBubblePhotoImageView alloc] initWithFrame:CGRectZero];
        _imgViewImage.type = MessageTypeReceiving;
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
        _placeholderImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _placeholderImg;
}

#pragma mark - Private Method

- (void)sendNotify
{
    [[NSNotificationCenter defaultCenter] postNotificationName:MTImageDidFinishedLoadNotification  object:self.baseModel];
}

@end

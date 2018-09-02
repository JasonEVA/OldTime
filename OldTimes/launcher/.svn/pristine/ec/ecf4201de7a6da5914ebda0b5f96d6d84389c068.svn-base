//
//  MsgImagePasteView.m
//  Titans
//
//  Created by Remon Lv on 14/12/7.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MsgImagePasteView.h"
#import "MyDefine.h"
#import "Slacker.h"
#import "QuickCreateManager.h"
#import "NSString+Manager.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Hex.h"

#define H_MAX       200
#define W_MAX      100
#define M_ALL        10
#define H_BTN        40
#define My_CornerRadius     5.0

@implementation MsgImagePasteView

- (id)initWithTarget:(id)target ActionSend:(SEL)actionSend ImageUrl:(NSURL *)imgUrl
{
    if (self = [super init])
    {
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];
        CGRect rect = [UIApplication sharedApplication].keyWindow.bounds;
        [self setFrame:rect];
        
        // 中间容器
        _viewShow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width - 2 * M_ALL, 0)];
        [_viewShow setBackgroundColor:[UIColor whiteColor]];
        [_viewShow.layer setCornerRadius:My_CornerRadius];
        [self addSubview:_viewShow];
        
        // 图片容器
        // 计算默认图片的尺寸
        UIImage *image = IMG_PLACEHOLDER_LOADING;
        CGSize s_img = image.size;
        CGFloat w_new, h_new;
        if (s_img.width > s_img.height)
        {
            // 约束宽度
            w_new = W_MAX;
            h_new =w_new * s_img.height / s_img.width;
        }
        else
        {
            // 约束高度
            h_new = H_MAX;
            w_new = h_new * s_img.width / s_img.height;
        }
        _imgView = [QuickCreateManager creatImageViewWithFrame:CGRectMake((_viewShow.frame.size.width - w_new) / 2, M_ALL, w_new, h_new) Image:image];
        [_imgView.layer setCornerRadius:3.0];
        [_imgView.layer setMasksToBounds:YES];
        [_viewShow addSubview:_imgView];
        
        // 分隔线
        _viewSeperateLine= [[UIView alloc] initWithFrame:CGRectMake(0, [Slacker getValueWithFrame:_imgView.frame WithX:NO] + M_ALL, _viewShow.frame.size.width, 0.5)];
        [_viewSeperateLine setBackgroundColor:[UIColor lightGrayColor]];
        [_viewShow addSubview:_viewSeperateLine];
        
        // 两个按钮
        CGFloat w_btn = (_viewShow.frame.size.width - 3 * M_ALL) / 2;
        _btnCancel = [QuickCreateManager creatButtonWithFrame:CGRectMake(M_ALL, M_ALL + [Slacker getValueWithFrame:_viewSeperateLine.frame WithX:NO], w_btn, H_BTN) Title:LOCAL(CANCEL) TitleFont:[UIFont systemFontOfSize:17] TitleColor:[UIColor blackColor] BgImage:nil HighImage:nil BgColor:[UIColor whiteColor] Tag:0];
        [_btnCancel.layer setCornerRadius:My_CornerRadius];
        [_btnCancel.layer setBorderWidth:0.5];
        [_btnCancel.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [_viewShow addSubview:_btnCancel];
        
        _btnSend = [QuickCreateManager creatButtonWithFrame:CGRectMake(M_ALL + [Slacker getValueWithFrame:_btnCancel.frame WithX:YES], _btnCancel.frame.origin.y, w_btn, H_BTN) Title:LOCAL(SEND) TitleFont:[UIFont systemFontOfSize:17] TitleColor:[UIColor whiteColor] BgImage:nil HighImage:nil BgColor:[UIColor mtc_colorWithR:24 g:202 b:150] Tag:0];
        [_btnSend.layer setCornerRadius:My_CornerRadius];
        [_btnSend.layer setBorderWidth:0.5];
        [_btnSend.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [_btnSend addTarget:target action:actionSend forControlEvents:UIControlEventTouchUpInside];
        [_viewShow addSubview:_btnSend];
        
        // 重设高度
        CGRect newFrame = _viewShow.frame;
        newFrame.size.height = 4 * M_ALL + H_BTN + _imgView.frame.size.height;
        _viewShow.frame = newFrame;
        [_viewShow setCenter:self.center];
        
        // 等待指示器
        _viewIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        [_viewIndicator setHidesWhenStopped:YES];
        [_viewIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [_viewIndicator setCenter:_imgView.center];
        [_viewShow addSubview:_viewIndicator];
        
        // 图片加载失败的提示器
        _lbError = [QuickCreateManager creatLableWithFrame:CGRectMake(0, _imgView.bounds.size.height - 40, _imgView.bounds.size.width, 40) Text:LOCAL(IMAGE_FAILLOAD) Font:[UIFont systemFontOfSize:14] Alignment:NSTextAlignmentCenter Color:[UIColor blackColor]];
        [_imgView addSubview:_lbError];
        [_lbError setHidden:YES];
        
        // 判断是本地路径还是httpUrl
        // 先解除伪装
        NSString *strImg = [imgUrl absoluteString];
        if ([strImg hasPrefix:@"//"])
        {
            strImg = [strImg substringFromIndex:2];
        }
        if ([strImg checkHttpUrlWithString])
        {
            // 禁止发送按钮
            [_btnSend setEnabled:NO];
            [_viewIndicator startAnimating];
            __block MsgImagePasteView *blockSelf = self;
            [_imgView setImageWithURL:[NSURL URLWithString:strImg] placeholderImage:IMG_PLACEHOLDER_LOADING completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
             {
                 [blockSelf->_viewIndicator stopAnimating];
                 if (image != nil)
                 {
                     // 重置图片容器Frame
                     // 计算图片的尺寸
                     CGSize s_img = image.size;
                     CGFloat w_new, h_new;
                     if (s_img.width > s_img.height)
                     {
                         // 约束宽度
                         w_new = W_MAX;
                         h_new =w_new * s_img.height / s_img.width;
                     }
                     else
                     {
                         // 约束高度
                         h_new = H_MAX;
                         w_new = h_new * s_img.width / s_img.height;
                     }
                     
                     [blockSelf->_imgView setFrame:CGRectMake((blockSelf->_viewShow.frame.size.width - w_new) / 2, M_ALL, w_new, h_new)];
                     
                     // 分隔线
                     [blockSelf->_viewSeperateLine setFrame:CGRectMake(0, [Slacker getValueWithFrame:blockSelf->_imgView.frame WithX:NO] + M_ALL, blockSelf->_viewShow.frame.size.width, 0.5)];;
                     
                     // 两个按钮
                     CGFloat w_btn = (blockSelf->_viewShow.frame.size.width - 3 * M_ALL) / 2;
                     [blockSelf->_btnCancel setFrame:CGRectMake(M_ALL, M_ALL + [Slacker getValueWithFrame:blockSelf->_viewSeperateLine.frame WithX:NO], w_btn, H_BTN)];
                     [blockSelf->_btnSend setFrame:CGRectMake(M_ALL + [Slacker getValueWithFrame:blockSelf->_btnCancel.frame WithX:YES], blockSelf->_btnCancel.frame.origin.y, w_btn, H_BTN)];
                     
                     // 重设高度
                     CGRect newFrame = blockSelf->_viewShow.frame;
                     newFrame.size.height = 4 * M_ALL + H_BTN + blockSelf->_imgView.frame.size.height;
                     blockSelf->_viewShow.frame = newFrame;
                     [blockSelf->_viewShow setCenter:blockSelf.center];
                     
                     // 放到黏贴板
                     [[UIPasteboard generalPasteboard] setImage:image];
                     
                     // 解禁发送按钮
                     [blockSelf->_btnSend setEnabled:YES];
                 }
                 else
                 {
                    [blockSelf->_lbError setHidden:NO];
                     [blockSelf->_btnSend setBackgroundColor:[UIColor lightGrayColor]];
                 }
            }];
        }
        else
        {
            UIImage *image = [UIImage imageWithContentsOfFile:strImg];
            // 放到黏贴板
            [[UIPasteboard generalPasteboard] setImage:image];
            
            // 计算图片的尺寸
            CGSize s_img = image.size;
            CGFloat w_new, h_new;
            if (s_img.width > s_img.height)
            {
                // 约束宽度
                w_new = W_MAX;
                h_new =w_new * s_img.height / s_img.width;
            }
            else
            {
                // 约束高度
                h_new = H_MAX;
                w_new = h_new * s_img.width / s_img.height;
            }
            
            // 图片容器
            [_imgView setFrame:CGRectMake((_viewShow.frame.size.width - w_new) / 2, M_ALL, w_new, h_new)];
            [_imgView setImage:image];
            
            // 分隔线
            [_viewSeperateLine setFrame:CGRectMake(0, [Slacker getValueWithFrame:_imgView.frame WithX:NO] + M_ALL, _viewShow.frame.size.width, 0.5)];;
            
            // 两个按钮
            CGFloat w_btn = (_viewShow.frame.size.width - 3 * M_ALL) / 2;
            [_btnCancel setFrame:CGRectMake(M_ALL, M_ALL + [Slacker getValueWithFrame:_viewSeperateLine.frame WithX:NO], w_btn, H_BTN)];
            [_btnSend setFrame:CGRectMake(M_ALL + [Slacker getValueWithFrame:_btnCancel.frame WithX:YES], _btnCancel.frame.origin.y, w_btn, H_BTN)];

            // 重设高度
            CGRect newFrame = _viewShow.frame;
            newFrame.size.height = 4 * M_ALL + H_BTN + _imgView.frame.size.height;
            _viewShow.frame = newFrame;
            [_viewShow setCenter:self.center];
        }
    }
    return self;
}

- (void)show
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

#pragma mark - Private Method
- (void)cancel
{
    [self dismiss];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  MsgImagePasteView.h
//  Titans
//
//  Created by Remon Lv on 14/12/7.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  复制黏贴图片弹出的确认View（仿微信）

#import <UIKit/UIKit.h>

@interface MsgImagePasteView : UIView
{
    UIView *_viewShow;                      // 中间容器
    UIImageView *_imgView;              // 图片显示容器
    UIButton *_btnCancel, *_btnSend;
    UIView *_viewSeperateLine;          // 分隔线
    UIActivityIndicatorView *_viewIndicator;        // 图片加载指示器
    UILabel *_lbError;                          // 图片加载失败的提示
}

- (id)initWithTarget:(id)target ActionSend:(SEL)actionSend ImageUrl:(NSURL *)imgUrl;

- (void)show;
- (void)dismiss;

@end

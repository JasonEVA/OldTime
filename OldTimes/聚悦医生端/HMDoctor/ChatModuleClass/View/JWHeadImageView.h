//
//  JWHeadImageView.h
//  HMDoctor
//
//  Created by jasonwang on 2017/4/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//  自带默认图的头像

#import <UIKit/UIKit.h>

@interface JWHeadImageView : UIView
// 有url图片就展示，没有就使用string展示（采用SDWebImage）
- (void)fillImageWithName:(NSString *)name url:(NSURL *)url;

// 本地根据nikeName生成图片
- (void)fillImageWithName:(NSString *)name;

// 使用本地指定图片
- (void)fillImageWithImage:(UIImage *)image;
@end

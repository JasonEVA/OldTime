//
//  VideoPlayerView.h
//  Shape
//
//  Created by Andrew Shen on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  视屏播放view

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerView : UIView
- (instancetype)initWithPlayer:(AVPlayer *)player;
@end

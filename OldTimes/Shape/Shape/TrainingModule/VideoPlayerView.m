//
//  VideoPlayerView.m
//  Shape
//
//  Created by Andrew Shen on 15/11/12.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "VideoPlayerView.h"

@interface VideoPlayerView()
@property (nonatomic, strong)  AVPlayer  *player; // <##>
@end
@implementation VideoPlayerView

- (instancetype)initWithPlayer:(AVPlayer *)player {
    if (self = [super init]) {
        self.player = player;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //创建播放器层
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = self.frame;
//    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;//视频填充模式
    [self.layer addSublayer:playerLayer];

}


@end

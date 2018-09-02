//
//  AudionPlayHelper.h
//  HMClient
//
//  Created by lkl on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef void (^playStop)();
@interface AudioPlayHelper : NSObject

+ (id) shareInstance;
@property(nonatomic,strong)playStop block;
- (void) playAudioPath:(NSString*) path;


- (void) playAudioData:(NSData*)data callBack:(playStop)block;

- (void)stopPlay;

- (BOOL)isPlaying;
@end

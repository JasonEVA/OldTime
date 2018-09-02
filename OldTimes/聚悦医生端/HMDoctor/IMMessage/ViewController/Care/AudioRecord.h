//
//  AudioRecord.h
//  HMDoctor
//
//  Created by lkl on 16/6/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioRecord : NSObject

@property (nonatomic,assign) int duration;

- (NSString*) cacheDir;

- (void) startRecord;

- (void) stopRecord;

@end

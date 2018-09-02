//
//  ChatForwardBubbleUtil.h
//  launcher
//
//  Created by williamzhang on 16/4/1.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  消息转发bubble

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>

@interface ChatForwardBubbleUtil : NSObject

+ (UIImage *)bubbleImageViewIsLeft:(BOOL)isLeft;

/** williamzhang:[图片] */
+ (NSString *)singleMessageForwardFormate:(MessageBaseModel *)message;

@end

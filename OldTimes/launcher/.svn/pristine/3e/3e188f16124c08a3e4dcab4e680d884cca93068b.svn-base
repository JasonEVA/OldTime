//
//  ChatForwardBubbleUtil.m
//  launcher
//
//  Created by williamzhang on 16/4/1.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatForwardBubbleUtil.h"
#import "IMNickNameManager.h"
#import "MyDefine.h"

@implementation ChatForwardBubbleUtil

+ (UIImage *)bubbleImageViewIsLeft:(BOOL)isLeft {
    UIImage *image = [UIImage imageNamed:@"ChatForwardMessageBubble"];
    return isLeft ? [self wz_horizontallyFlippedImageFromImage:image] : image;
}

+ (NSString *)singleMessageForwardFormate:(MessageBaseModel *)message {
    NSString *nickName = [message getNickName];
    NSString *content = @"";
    switch (message._type) {
        case msg_personal_file:     content = [NSString stringWithFormat:@"[%@]", LOCAL(NEWAPPLY_ATTACHMENT)]; break;
        case msg_personal_text:     content = message._content; break;
        case msg_personal_image:    content = [NSString stringWithFormat:@"[%@]", LOCAL(CHAT_IMAGE_TITEL)]; break;
        case msg_personal_voice:    content = [NSString stringWithFormat:@"[%@]", LOCAL(MESSAGE_VOICE)]; break;
            
        default:
            break;
    }
    
    return [NSString stringWithFormat:@"%@:%@", [IMNickNameManager showNickNameWithOriginNickName:nickName userId:[message getUserName]], content];
}

#pragma mark - Private Method
+ (UIImage *)wz_horizontallyFlippedImageFromImage:(UIImage *)image {
    return [UIImage imageWithCGImage:image.CGImage
                               scale:image.scale
                         orientation:UIImageOrientationUpMirrored];
}

@end

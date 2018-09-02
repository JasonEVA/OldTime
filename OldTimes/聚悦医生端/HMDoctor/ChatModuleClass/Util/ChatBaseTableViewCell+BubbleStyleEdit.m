//
//  ChatBaseTableViewCell+BubbleStyleEdit.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/9/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChatBaseTableViewCell+BubbleStyleEdit.h"

@implementation ChatBaseTableViewCell (BubbleStyleEdit)

// 气泡填充颜色
- (void)ats_changeBubbleTintColor:(UIColor *)tintColor {
    self.imgViewBubble.tintColor = tintColor;
}


- (void)ats_changeBubbleBackgroundImage:(UIImage *)image {
    self.imgViewBubble.tintColor = [UIColor whiteColor];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height * 0.8];
//    [self.imgViewBubble setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [self.imgViewBubble setImage:image];
}

@end

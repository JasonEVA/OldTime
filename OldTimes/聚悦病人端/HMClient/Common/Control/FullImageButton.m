//
//  FullImageButton.m
//  HMClient
//
//  Created by yinqaun on 16/4/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "FullImageButton.h"

@implementation FullImageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(3, 3, contentRect.size.width - 6, contentRect.size.height - 6);
}

@end

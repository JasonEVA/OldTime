//
//  MuscleImageView.m
//  Shape
//
//  Created by Andrew Shen on 15/10/22.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MuscleImageView.h"

@implementation MuscleImageView

- (instancetype)initWithImage:(UIImage *)image  highlightedImage:highlightedImage target:(id)target gestureAction:(SEL)gestureAction tag:(NSInteger)tag {
    self = [super initWithImage:image highlightedImage:highlightedImage];
    if (self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:target action:gestureAction];
        [self addGestureRecognizer:gest];
        self.tag = tag;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //Using code from http://stackoverflow.com/questions/1042830/retrieving-a-pixel-alpha-value-for-a-uiimage
    
    unsigned char pixel[1] = {0};
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 4, NULL,
                                                 kCGImageAlphaOnly);
    UIGraphicsPushContext(context);
    [self.image drawAtPoint:CGPointMake(-point.x, -point.y)];
    UIGraphicsPopContext();
    CGContextRelease(context);
    CGFloat alpha = pixel[0]/255.0f;
    BOOL transparent = alpha < 0.01f;
    
    return !transparent;
}

@end

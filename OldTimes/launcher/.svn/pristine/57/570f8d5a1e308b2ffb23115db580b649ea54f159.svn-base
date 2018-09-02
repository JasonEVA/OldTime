//
//  BaseButton.m
//  launcher
//
//  Created by Lars Chen on 15/11/11.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "BaseButton.h"
#import "UIColor+Hex.h"

@interface BaseButton ()

@property (nonatomic, strong) UIImage *normalImage;
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation BaseButton

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor mtc_colorWithHex:0xebebeb];
    }
    else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)wz_setImage:(UIImage *)image forState:(WZControlState)state {
    [self setImage:image forState:(UIControlState)state];

    if (state == WZControlStateNormal) {
        self.normalImage = image;
    } else if (state == WZControlStateSelected) {
        self.selectedImage = image;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    UIImage *image = selected ? self.selectedImage : self.normalImage;

    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateSelected];
}

@end

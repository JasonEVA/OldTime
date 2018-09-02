//
//  ATSegmentedControl.m
//  Clock
//
//  Created by SimonMiao on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATSegmentedControl.h"

@implementation ATSegmentedControl

- (instancetype)initWithItems:(NSArray *)items
                      bgColor:(UIColor *)bgColor
                  borderColor:(UIColor *)borderColor
                selTitleColor:(UIColor *)selTitleColor
                norTitleColor:(UIColor *)norTitleColor
                    tintColor:(UIColor *)tintColor
                 cornerRadius:(CGFloat)cornerRadius
                    addTarget:(id)target
                     selector:(SEL)selector
{
    self = [super initWithItems:items];
    if (self) {
        self.selectedSegmentIndex = 0;
        self.backgroundColor = bgColor;
        self.layer.borderWidth = 1;
        self.layer.borderColor = borderColor.CGColor;
        
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : selTitleColor} forState:UIControlStateSelected];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName : norTitleColor} forState:UIControlStateNormal];
        self.tintColor = tintColor;
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
        
        [self addTarget:target action:selector forControlEvents:UIControlEventValueChanged];
    }
    
    return self;
}

@end

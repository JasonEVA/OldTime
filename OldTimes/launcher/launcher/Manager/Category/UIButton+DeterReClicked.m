//
//  UIButton+DeterReClicked.m
//  launcher
//
//  Created by Simon on 16/5/30.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "UIButton+DeterReClicked.h"

@implementation UIButton (DeterReClicked)

- (void)mtc_deterClickedRepeatedly {
    self.enabled = NO;
    [self performSelector:@selector(mct_makeClickedButtonEnable) withObject:nil afterDelay:0.5];
    
}

- (void)mct_makeClickedButtonEnable {
    self.enabled = YES;
}

@end

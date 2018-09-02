//
//  UILable+FontFit.h
//  HMClient
//
//  Created by yinquan on 16/9/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UILabel (FontFit)
{
    
}

- (void) setFontFit:(UIFont *)font;
@end

@interface UITextView (FontFit)

- (void) setFontFit:(UIFont *)font;
@end

@interface UITextField (FontFit)

- (void) setFontFit:(UIFont *)font;
@end

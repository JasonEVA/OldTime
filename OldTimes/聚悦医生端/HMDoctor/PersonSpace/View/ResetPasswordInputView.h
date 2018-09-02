//
//  ResetPasswordInputView.h
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordInputView : UIView
{
    
}

@property (nonatomic, readonly) UITextField* tfPassowrd;

- (void) setName:(NSString*) name;
- (void) setPlaceholder:(NSString*) placeholder;

@end

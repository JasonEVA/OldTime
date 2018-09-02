//
//  ForgetPasswordInputView.h
//  HMDoctor
//
//  Created by lkl on 16/6/28.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPasswordInputView : UIView
{
    
}

@property (nonatomic, readonly) UITextField* tfPassowrd;
@property (nonatomic, retain) UIButton* mobileConfirmBtn;

- (void) setName:(NSString*) name;
- (void) setPlaceholder:(NSString*) placeholder;

@end
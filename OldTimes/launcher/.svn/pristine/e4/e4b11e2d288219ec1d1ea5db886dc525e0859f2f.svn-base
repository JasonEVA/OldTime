//
//  ApplicationInputView.h
//  launcher
//
//  Created by William Zhang on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  应用内输入

#import <UIKit/UIKit.h>

@class BaseViewController;

@protocol ApplicationInputViewDelegate <NSObject>

- (void) ApplicationInputViewDelegateCallBack_didStartEdit;
- (void) ApplicationInputViewDelegateCallBack_atUser:(UITextView *)textView;

@end

@interface ApplicationInputView : UIView

@property (nonatomic, readonly) NSString *inputText;

@property (nonatomic, weak) id<ApplicationInputViewDelegate> dalegate;
- (void)clearText;

- (void)sendText:(void (^)(NSString *text))textBlock;
- (void)selectImage:(void (^)(UIImage *selectedImage))selectImageBlock;

- (instancetype)initWithViewController:(BaseViewController *)viewController;
- (void)resignfirstResponder;
@end

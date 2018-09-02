//
//  InputView.h
//  Shape
//
//  Created by jasonwang on 15/10/28.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginInputView;
@protocol LoginInputViewDelegate <NSObject>
//开始编辑回调
- (void)LoginInputViewDelegateCallBack_statrEditing:(LoginInputView *)view;

//结束编辑回调
- (void)LoginInputViewDelegateCallBack_endEditing:(LoginInputView *)view;
@end

@interface LoginInputView : UIView
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, weak) id <LoginInputViewDelegate> delegate;

- (instancetype)initWithImageName:(NSString *)imageName hightLightImgName:(NSString *)hightLightImgName placeHoderText:(NSString *)placeHoderText;
//设置选中方法
- (void)setStatus:(BOOL)isSelect;
@end

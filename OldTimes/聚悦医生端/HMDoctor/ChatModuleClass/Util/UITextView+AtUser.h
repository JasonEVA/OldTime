//
//  UITextView+AtUser.h
//  launcher
//
//  Created by williamzhang on 15/12/4.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  @User使用

#import <UIKit/UIKit.h>

@class ContactInfoModel;

@interface NSAttributedString (Identifier)

@property (nonatomic, readonly) NSString *identifier;

@end

@interface UITextView (AtUser)

- (BOOL)wz_shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

- (void)addAtUser:(ContactInfoModel *)atUser deleteFrontAt:(BOOL)deleteFrontAt;

@end

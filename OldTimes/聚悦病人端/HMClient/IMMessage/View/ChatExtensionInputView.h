//
//  ChatExtensionInputView.h
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChatExtensionInputDelegate <NSObject>

- (void) caremaButtonClicked;
- (void) pictureButtonClicked;

@end

@interface ChatExtensionInputView : UIView
{
    
}

@property (nonatomic, weak) id<ChatExtensionInputDelegate> delegate;
@end

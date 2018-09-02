//
//  ChartInputView.h
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChartInputDelegate <NSObject>
@optional
- (void) appendbuttonClicked;
- (void) inputtypebuttonClicked;
- (void) textInput:(NSString*) text;

- (void) textInputAt;       //输入@
- (void) voicestartrecord;
- (void) voiceendrecord;
@end

@interface ChartInputView : UIView
{
    
}

@property (nonatomic, weak) id<ChartInputDelegate> delegate;

- (void) appendAtStaff:(NSString*) staffname;
@end

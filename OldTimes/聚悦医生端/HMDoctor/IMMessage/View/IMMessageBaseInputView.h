//
//  IMMessageBaseInputView.h
//  HMDoctor
//
//  Created by yinquan on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMMessageBaseInputView : UIView
{
    
}

@property (nonatomic, readonly) UIButton* leftbutton;
@property (nonatomic, readonly) UIButton* rightbutton;
@property (nonatomic, readonly) UIView* messageview;


- (void) createSubViews;
- (void) subviewsLayouts;

@end

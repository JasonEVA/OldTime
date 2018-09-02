//
//  HMSwitchView.h
//  HMClient
//
//  Created by yinqaun on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMSwitchViewDelegate;

@interface HMSwitchView : UIView
{
    
}

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<HMSwitchViewDelegate> delegate;

- (void) createCells:(NSArray*) titles;
- (void) setTitle:(NSString*) title forIndex:(NSInteger) index;
@end

@protocol HMSwitchViewDelegate <NSObject>

- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSInteger) selectedIndex;


@end

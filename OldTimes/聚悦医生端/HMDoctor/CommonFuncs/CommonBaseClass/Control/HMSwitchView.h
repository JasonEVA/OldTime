//
//  HMSwitchView.h
//  HMDoctor
//
//  Created by yinquan on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMSwitchViewDelegate;

@interface HMSwitchView : UIView
{
    
}
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id<HMSwitchViewDelegate> delegate;

- (void) createCells:(NSArray*) titles;

- (void) setCellTitle:(NSString*) title index:(NSInteger) index;
@end


@protocol HMSwitchViewDelegate <NSObject>

- (void) switchview:(HMSwitchView*) switchview SelectedIndex:(NSUInteger) selectedIndex;

@end

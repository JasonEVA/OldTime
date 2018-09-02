//
//  MissionPickerBar.h
//  launcher
//
//  Created by Kyle He on 15/8/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  灰色的footerview

#import <UIKit/UIKit.h>


@protocol MissionPickerBarDelegate <NSObject>

@optional
- (void)MissionPickerBarDelegateCallBack_setEventStateNameWithIndex:(NSInteger)index;
- (void)MissionPickerBarDelegateCallBack_optionsSelected;
@end

@interface MissionPickerBar : UIView

@property(nonatomic, weak) id<MissionPickerBarDelegate>  delegate;

@end

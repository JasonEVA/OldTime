//
//  ApplyAddDeadlineActionSheetView.h
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  承认期限的actionsheet页面

#import <UIKit/UIKit.h>

@protocol ApplyAddDeadlineActionSheetViewDelegate <NSObject>

@optional
- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate*)date;
- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_isWholeDay:(BOOL) isWholdDay;
- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_closeDeadlineSwitch;

- (void)ApplyAddDeadlineActionSheetViewDelegateCallBack_date:(NSDate*)date isWholeDay:(BOOL)wholeDay;
@end

@interface ApplyAddDeadlineActionSheetView : UIView

@property (nonatomic, weak) id<ApplyAddDeadlineActionSheetViewDelegate> delegate;

@property (nonatomic, assign) BOOL showWholeDayMode;

@property (nonatomic, strong) id identifier;

- (void)showWholeDay:(BOOL)showWholeDay;

@end

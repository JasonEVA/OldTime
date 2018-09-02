//
//  CalendarDayCellView.h
//  Titans
//
//  Created by Wythe Zhou on 11/3/14.
//  Copyright (c) 2014 Remon Lv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDateDataModel.h"
#import "UIColor+Hex.h"

@protocol CalendarDayCellViewDelegate <NSObject>

// 按键点击回调
- (void)CalendarDayCellViewDelegateCallBack_ButtonClickedWithDateDataModel:(CalendarDateDataModel *)dateDataModel;

@end


@interface CalendarDayCellView : UIView
{
    CGFloat _wButton;      // 按键宽度
    CGFloat _hButton;      // 按键高度
    UIFont *_fontButtonTitle;   // 按键button
    
    // 颜色信息
    UIColor *_colorButtonTitleWhite;
    UIColor *_colorButtonTitleBlack;
    UIColor *_colorButtonTitleGray;
    UIColor *_colorButtonTitleBlue;
    UIColor *_colorButtonTitleRed;
    
    UIColor *_colorButtonBackgroundWhite;
    UIColor *_colorButtonBackgroundBlue;
    UIColor *_colorButtonBackgroundLightBlue;
    UIColor *_colorButtonBackgroundBlack;
    UIColor *_colorButtonBackgroundLightGray;
    

    // 内含的 button
    UIButton *_button;
    
    NSMutableArray *_arrayPoints;   // 存储颜色点，防止重用颜色点串
}

@property (nonatomic, strong) CalendarDateDataModel *_dateDataModel;      // 每天的信息
@property (nonatomic) BOOL _ifMonthOrDatePage;                      // 月视图或者天视图
@property (nonatomic) BOOL _isEventList;
@property (nonatomic, strong) UIImageView *imgViewEventPoint;       //事件显示的小圆点

@property (nonatomic, weak) id <CalendarDayCellViewDelegate> delegate;
- (void)setDateDataModel:(CalendarDateDataModel *)dateDataModel;    // 更新状态
- (void)refreshStatus;  // 更新状态
- (void)setDayCellViewSelected:(BOOL)isSelected;
@end

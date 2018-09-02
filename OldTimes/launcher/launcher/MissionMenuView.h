//
//  MissionMenuView.h
//  launcher
//
//  Created by Kyle He on 15/8/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  底部的menu

#import <UIKit/UIKit.h>
typedef enum {
    kmenuBtn = 100,
    kaddBtn = 101
}BtnType;
@protocol MissionMenuViewDelegate <NSObject>

@optional
- (void)missionMenuViewDelegateCallBack_showKeyBoardWithIndex:(NSInteger)index;

@end

@interface MissionMenuView : UIView

@property(nonatomic, weak) id<MissionMenuViewDelegate>delegate;

@end

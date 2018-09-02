//
//  MissionNavBar.h
//  launcher
//
//  Created by Kyle He on 15/8/27.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  顶部导航栏

#import <UIKit/UIKit.h>

@class MissionNavBar, TaskWhiteBoardModel;

typedef NS_ENUM(NSUInteger, MissionNavBarStyle) {
    MissionNavBarStyleDefault,
    MissionNavBarStyleWithoutAdd
};

@protocol MissionNavBarDelegate <NSObject>

@optional

- (void)missionNavBar:(MissionNavBar *)navBar refreshWithSelectedWhiteBoard:(TaskWhiteBoardModel *)whiteBoard;
- (void)missionNavBarShowEditVC:(MissionNavBar *)navBar;
/** 获取白板失败 */
- (void)missionNavBarShowFailed:(NSString *)errorMsg;

@end

@interface MissionNavBar : UIView

@property(nonatomic, weak) id<MissionNavBarDelegate> delegate;

@property (nonatomic, readonly) MissionNavBarStyle style;

- (instancetype)initWithFrame:(CGRect)frame style:(MissionNavBarStyle)style;

/** 根据project显示白板，可以是空 */
- (void)showWithProjectId:(NSString *)showId;
/** 白板修好后更新 */
- (void)updateWhiteboard:(NSArray *)whiteboard;

/** 根据project显示白板，可以是空，footerView时才用到current。。。Id */
- (void)showWithArray:(NSArray *)whiteBoards currentWhiteBoardId:(NSString *)currentWhiteBoardId;

@end

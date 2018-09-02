//
//  MainTabbarView.h
//  HMDoctor
//
//  Created by yinqaun on 16/4/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabbarCell : UIControl
@property (nonatomic, strong) UILabel *allUnReadCountLb;   //未读数红点

@end

@protocol MainTabbarDelegate <NSObject>

- (void) tabbarSelected:(NSInteger) selectedIndex;

@end

@interface MainTabbarView : UIView
{
    
}
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, weak) id<MainTabbarDelegate> delegate;
@property (nonatomic, strong)  NSMutableArray* tabbarCells;

// 设置消息红点
- (void)showRedPointAtIndex:(NSInteger)index show:(BOOL)show;

// 设置红点数字
- (void)showRedPointAtIndex:(NSInteger)index withCount:(NSInteger)count;
@end

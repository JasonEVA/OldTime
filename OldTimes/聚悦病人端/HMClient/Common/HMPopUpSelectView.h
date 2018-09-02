//
//  HMPopUpSelectView.h
//  HMClient
//
//  Created by lkl on 2017/8/16.
//  Copyright © 2017年 YinQ. All rights reserved.
//  通用弹出框

#import <UIKit/UIKit.h>

@interface PopUpSelectModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *ID;
@end

typedef NS_ENUM(NSInteger, PopUp) {
    PopUp_Small,   //小窗口，把View的位置转换到当前视图中
    PopUp_Whole,   //显示在整个View上
};

@interface HMPopUpSelectView : UIView

@property (nonatomic, assign) PopUp popUpType;

/*
 显示在整个View上
 title        是否显示表示
 dataArray    数组
 */
+ (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title dataArray:(NSArray *)dataArr block:(void(^)(NSDictionary *))block;

/*
 把View的位置转换到当前视图中
 popUpRect    显示的坐标Rect
 dataArray    数组
 */
+ (instancetype)initWithFrame:(CGRect)frame popUpRect:(CGRect)popUpRect dataArray:(NSArray *)dataArr block:(void(^)(NSDictionary *))block;

@property (nonatomic, copy) void(^dataSelectBlock)(NSDictionary *dic);

@property (nonatomic, assign) CGRect popUpRect;
@property (nonatomic, copy) NSString *popupTitle;  //显示的标题

@end

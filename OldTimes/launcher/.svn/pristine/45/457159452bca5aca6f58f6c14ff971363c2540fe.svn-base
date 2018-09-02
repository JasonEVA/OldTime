//
//  NewPopUpCalendarListView.h
//  launcher
//
//  Created by TabLiu on 16/3/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//
//  月弹出

#import <UIKit/UIKit.h>

@class NewCalendarWeeksModel;

typedef void(^jumptoadd)(NSDate *);

typedef NS_ENUM(NSInteger , NewPopUpCalendarListViewBlockType)
{
    blockType_pop = 0,
    blockType_CreatEvent,
    blockType_CreatMetting,
    blockType_Calendar
};
typedef  void(^NewPopUpCalendarListViewBlock)(NewPopUpCalendarListViewBlockType  type, NewCalendarWeeksModel * model);

@interface NewPopUpCalendarListView : UIView

@property (nonatomic,strong) NSString * logName;

- (id)initWithFrame:(CGRect)frame;

- (void)setDisMissBlock:(NewPopUpCalendarListViewBlock)block;
- (void)setJumptoaddeventnblock:(jumptoadd)block;
- (void)setLookCalendarUID:(NSString*)uid IsReadOnly:(BOOL)readOnly;
- (void)setNewDate:(NSDate *)date;

@end

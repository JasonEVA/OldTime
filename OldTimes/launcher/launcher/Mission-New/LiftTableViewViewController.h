//
//  LiftTableViewViewController.h
//  launcher
//
//  Created by TabLiu on 16/2/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"

@class ProjectContentModel;

#define LIFT_TABLEVIEW_WIDTH ([ [ UIScreen mainScreen ] bounds ].size.width)*0.8

typedef void (^tableViewSelectForRow)(NSIndexPath *path,ProjectContentModel *model);
typedef void (^viewWillAppearBlock)(BOOL isShow);

@interface LiftTableViewViewController : BaseViewController

- (void)setCellSelectForRowBlock:(tableViewSelectForRow)block;
- (void)setViewWillAppearBlock:(viewWillAppearBlock)block;

- (void)changeSelectCellWithPath:(NSIndexPath *)path showId:(NSString *)showId;

- (void)selectAtIndex:(NSInteger)index;

@end

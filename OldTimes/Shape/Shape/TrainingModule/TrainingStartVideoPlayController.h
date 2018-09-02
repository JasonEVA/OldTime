//
//  TrainingStartVideoPlayController.h
//  Shape
//
//  Created by jasonwang on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  训练开始，播放视频页

#import "BaseViewController.h"

@class TrainActionListModel;

@interface TrainingStartVideoPlayController : BaseViewController
@property (nonatomic, copy) NSString *trainID;
@property (nonatomic, copy)  NSArray<TrainActionListModel *>  *arrayActionList; // <##>
@end

//
//  NewDetailMissionViewController.h
//  launcher
//
//  Created by jasonwang on 16/2/18.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  任务详情页

#import "ApplicationCommentBaseViewController.h"
@class TaskListModel;

typedef enum{
    DVCkind_nil = 0,
    DVCkind_Today,
    DVCkind_Tomorrow,
    DVCkind_NoTime
}VCkindUsedforPass;

@interface NewDetailMissionViewController : ApplicationCommentBaseViewController
@property (nonatomic) BOOL isFirstVC;
@property (nonatomic, copy) NSString *strBeforeShowID;
@property (nonatomic, assign) VCkindUsedforPass myVCUsedto;
- (instancetype)initWithOnlyShowID:(NSString *)strshowid;
- (instancetype)initWithMissionDetailModel:(TaskListModel *)detailModel;
- (instancetype)initWithSubMission:(NSString *)showID;
- (instancetype)initWithParentMission:(NSString *)showID;
@end

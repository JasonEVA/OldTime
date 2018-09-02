//
//  ProjectSearchDefine.h
//  launcher
//
//  Created by William Zhang on 15/9/14.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#ifndef launcher_ProjectSearchDefine_h
#define launcher_ProjectSearchDefine_h

#import "WhiteBoradStatusType.h"

typedef NS_ENUM(NSInteger, ProjectSearchType){
    ProjectSearchTypeNone = -1,
    /** 
     * 所有相关项目的任务
     */
    projectSearchTypeAll,
    /**
     * 单个或单个类型白板所有(DELETE不要了不要了)
     */
    projectSearchTypeAllMissionInProject,
    /**
     *  单个或单个类型白板所有
     */
    projectSearchTypeOneWhiteBoard,
    /**
     *  搜索我参与的
     */
    projectSearchTypeJoin,
    /**
     *  搜索我发出的
     */
    projectSearchTypeSendMyself,
    /**
     *  搜索今天截止
     */
    projectSearchTypeToday,
    /**
     *  搜索一周内截止
     */
    projectSearchTypeOneWeek,
};

#endif

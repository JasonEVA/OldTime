//
//  NotifyDefine.h
//  VerusKnight
//
//  Created by William Zhang on 15/1/5.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#ifndef VerusKnight_NotifyDefine_h
#define VerusKnight_NotifyDefine_h
/* ——————————————————————————NSNotifition——————————————————————————————-—— */
#pragma mark -- NSNotifition

#define NOTIFY_REFRESH_HEADPIC  @"RefreshHeadPic"   // 更新头像显示

static NSString * const notify_image_finish_loaded = @"imageFinishedLoad";

static NSString * const notify_show_singleChat = @"notify_show_singleChat";
static NSString * const notify_show_groupChat  = @"notify_show_groupChat";

static NSString * const notify_create_group = @"createGroup";

static NSString * const notify_tabbar_jump = @"notify_tabbar_jump";

static NSString * const notify_begin_qrCode = @"notify_begin_qrCode";
static NSString * const notify_begin_search = @"notify_begin_search";
static NSString * const notify_begin_calendar = @"notify_begin_calendar";

#endif

//
//  MyDefine.h
//  VerusKnight
//
//  Created by Andrew Shen on 15/1/2.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#ifndef launcher_MyDefine_h
#define launcher_MyDefine_h

#import "UrlInterfaceDefine.h"
#import "DeviceDefine.h"
#import "DefaultDefine.h"
#import "NotifyDefine.h"
#import "LocalDefine.h"
#import "UnifiedUserInfoManager.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "LogHeader.pch"


#define MTDeprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

/* —————————————————————————— 数学计算 ———————————————————————————————————————-—— */
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)

//#define Lumberjack Dec.11

#ifdef Lumberjack
static const NSInteger ddLogLevel = DDLogLevelAll;
#else
static const NSInteger ddLogLevel = DDLogLevelOff;

#endif


/* ——————————————————————————Other Var—————————————————————————————————--— */
#pragma mark - Other Var
#define HEIGTH_STATUSBAR 20                           // 状态栏高度
#define HEIGTH_NAVI  44                               // 导航栏高度
#define HEIGTH_TABBAR 49                              // 自定义底部栏的高度
#define HEIGTH_TOOLBAR  44                            // 自定义工具栏的高度
#define IMAGE_THUMBNAILS_SCALE 0.5                    // 缩略图压缩比例
#define DURATION_TIMEOUT 10                           // 网络请求超时时长
#define ATTACHMENT_DURATION_TIMEOUT 200               // 下载附件请求超时时长
#define DURATION_LOOP_LOGIN 10                        // SOCKET轮询登录时间
#define DURATION_CAPTCHA 60                           // 验证码请求间隔时长

#define SIZE_IMAGECOMPRESS CGSizeMake(200, 200)       // 上传头像压缩尺寸
#define INTERVAL_MAX_FORCHATSHOW  300                 // 两条聊天内容需要显示时间最大间隔

/* ——————————————————————————CommonUse Color——————————————————————————-—— */
#pragma mark - CommonUse Color
// 要加请在UIColor+Hex中添加

/* ——————————————————————————CommonUse Image——————————————————————————-—— */
#pragma mark - CommonUse Image
#define IMG_THEMEBLUE_NORMAL [UIImage imageNamed:@"btn_blue_normal"]
#define IMG_TRANSPARENT      [UIImage imageNamed:@"img_transparent"]
#define IMG_DEFAULT_HEAD     [UIImage imageNamed:@"contact_default_headPic"]   // 联系人默认头像


#define IMG_ARROWS [UIImage imageNamed:@"icon_arrows"]
#define IMG_BLUE_HIGHLIGHT [UIImage imageNamed:@"icon_blue_highlight"]
#define IMG_PINK_NORMAL [UIImage imageNamed:@"icon_pink_normal"]
#define IMG_PINK_HIGHLIGHT [UIImage imageNamed:@"icon_pink_highlight"]
#define IMG_PLACEHOLDER_HEAD [UIImage imageNamed:@"login_login_head"]
#define IMG_PLACEHOLDER_LOADING [UIImage imageNamed:@"image_placeholder_loading"]    //expried
#define IMG_PLACEHOLDER_EXPIRED [UIImage imageNamed:@"expried"]
#define IMG_BUTTON_NEXT [UIImage imageNamed:@"button_next"]

/* —————————————————————————— App信息 ——————————————————————————-—— */
#pragma mark - App信息

#define APP_VERSION @"Launchr V1.0 Beta"      // 软件本版本号
#define APP_ID      @"914404898"          // Apple Id
#define API_Key     @"772b0a5f875f0f37ea3f9f31f1f7c3eb"     // 地图API_KEY
#define URL_MINTCODE @"http://www.mintcode.com"     // 公司网页


// ************** 语言切换 **************//

#define LOCAL(a)            (LOCAL_FOLLOW_SYSTEM ? LOCAL_SYSTEM(a) : LOCAL_CUSTOM(a))
#define LOCAL_FOLLOW_SYSTEM [[UnifiedUserInfoManager share] isFollowSystemLanguage]
#define LOCAL_CUSTOM(a)     [[UnifiedUserInfoManager share] getCustomLocalizedValueWithKey:a]

#endif

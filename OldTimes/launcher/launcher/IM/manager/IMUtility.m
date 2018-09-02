//
//  IMUtility.m
//  launcher
//
//  Created by Andrew Shen on 15/10/8.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "IMUtility.h"
#import "UnifiedFilePathManager.h"

#define FILE_ICON_TXT       @"file_icon_txt"
#define FILE_ICON_RAR       @"file_icon_rar"
#define FILE_ICON_XML       @"file_icon_xml"
#define FILE_ICON_PDF       @"file_icon_pdf"
#define FILE_ICON_UNKNOWN   @"file_icon_unknown"
#define FILE_ICON_XLS       @"file_icon_xls"
#define FILE_ICON_HTML5     @"file_icon_html5"
#define FILE_ICON_IMAGE     @"file_icon_image"
#define FILE_ICON_WORD      @"file_icon_word"
#define FILE_ICON_PPT       @"file_icon_ppt"

#define APP_CALENDAR        @"chat_list_calendar"
#define APP_LEAVE           @"chat_list_leave"
#define APP_MISSION         @"chat_list_task"

@implementation IMUtility

// 通过文件名/文件路径得到文件类型图标
+ (UIImage *)fileIconFromFileName:(NSString *)fileName
{
    NSString *strName = @"";
    // 得到文件的扩展名
    NSString *extension = [fileName pathExtension];
    extension = [extension lowercaseString];
    if ([extension isEqualToString:@"txt"])
    {
        strName = FILE_ICON_TXT;
    }
    else if ([@[@"htm", @"html"] containsObject:extension])
    {
        strName = FILE_ICON_HTML5;
    }
    else if ([@[@"jpg", @"jpeg", @"png", @"gif"] containsObject:extension])
    {
        strName = FILE_ICON_IMAGE;
    }
    else if ([extension isEqualToString:@"xml"])
    {
        strName = FILE_ICON_XML;
    }
    else if ([@[@"doc", @"docx"] containsObject:extension])
    {
        strName = FILE_ICON_WORD;
    }
    else if ([@[@"xls", @"xlsx"] containsObject:extension])
    {
        strName = FILE_ICON_XLS;
    }
    else if ([@[@"ppt", @"pptx"] containsObject:extension])
    {
        strName = FILE_ICON_PPT;
    }
    else if ([extension isEqualToString:@"pdf"])
    {
        strName = FILE_ICON_PDF;
    }
    else if ([@[@"rar", @"zip"] containsObject:extension])
    {
        strName = FILE_ICON_RAR;
    }
    else
    {
        strName = FILE_ICON_UNKNOWN;
    }
    
    UIImage *img = [UIImage imageNamed:strName];
    return img;
}

@end

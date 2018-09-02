//
//  AttachmentUtil.h
//  launcher
//
//  Created by William Zhang on 15/9/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  附件上传下载工具

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AttachmentAppShowIdType) {
    /** 头像 */
    kAttachmentAppShowIdAvator = -10,
    kAttachmentAppShowIdApprove = 0,
    kAttachmentAppShowIdCalendar,
    kAttachmentAppShowIdTask,
    kAttachmentAppShowIdNewTask,
    kAttachmentAppShowIdAttendance
};

@interface AttachmentUtil : NSObject

+ (NSString *)attachmentShowIdFromType:(AttachmentAppShowIdType)appShowIdType;

+ (BOOL)isImage:(NSString *)fileName;
+ (UIImage *)attachmentIconFromFileName:(NSString *)fileName;

@end

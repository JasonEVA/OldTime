//
//  AttachmentUtil.m
//  launcher
//
//  Created by William Zhang on 15/9/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "AttachmentUtil.h"

@implementation AttachmentUtil

+ (NSDictionary *)attachmentShowIdDictionary {
    return @{
             @(kAttachmentAppShowIdAvator):@"",
             @(kAttachmentAppShowIdApprove):@"ADWpPoQw85ULjnQk",
             @(kAttachmentAppShowIdCalendar):@"l6b3YdE9LzTnmrl7",
             @(kAttachmentAppShowIdTask):@"PWP56jQLLjFEZXLe",
             @(kAttachmentAppShowIdNewTask):@"PWP16jQLLjFEZXLe",
             @(kAttachmentAppShowIdAttendance):@"ZD7O3xlJZGhBYPNx"
             };
}

+ (NSString *)attachmentShowIdFromType:(AttachmentAppShowIdType)appShowIdType {
    return [[self attachmentShowIdDictionary] objectForKey:@(appShowIdType)];
}

+ (BOOL)isImage:(NSString *)fileName {
    return [@[@"jpg", @"png", @"jpeg"] containsObject:fileName.pathExtension];
}

+ (UIImage *)attachmentIconFromFileName:(NSString *)fileName {
    NSString *prefix = @"file_icon_";
    NSString *suffix;
    
    NSString *extension = [fileName pathExtension];
    if ([extension isEqualToString:@"txt"]) {
        suffix = @"txt";
    }
    else if ([@[@"htm", @"html"] containsObject:extension]) {
        suffix = @"html5";
    }
    else if ([extension isEqualToString:@"xml"]) {
        suffix = @"xml";
    }
    else if ([@[@"doc", @"docx"] containsObject:extension]) {
        suffix = @"word";
    }
    else if ([@[@"xls", @"xlsx"] containsObject:extension]) {
        suffix = @"xls";
    }
    else if ([@[@"ppt", @"pptx"] containsObject:extension]) {
        suffix = @"ppt";
    }
    else if ([extension isEqualToString:@"pdf"]) {
        suffix = @"pdf";
    }
    else if ([@[@"rar", @"zip"] containsObject:extension]) {
        suffix = @"rar";
    }
    
    if (!suffix) {
        return nil;
    }
    
    NSString *imageName = [prefix stringByAppendingString:suffix];
    return [UIImage imageNamed:imageName];
}

@end

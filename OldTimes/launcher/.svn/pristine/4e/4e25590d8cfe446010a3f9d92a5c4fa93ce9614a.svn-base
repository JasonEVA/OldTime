//
//  ContactDetailModel+SQLUtil.h
//  MintcodeIM
//
//  Created by williamzhang on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactDetailModel.h"

@class FMResultSet;

// Sql_Column
static NSString * const contact_sqlid             =  @"_sqlId";            // sqlId
static NSString * const contact_headpic           =  @"_headPic";

static NSString * const contact_modified          =  @"_modified";

static NSString * const contact_target           = @"_target";
static NSString * const contact_nickName         = @"_nickName";
static NSString * const contact_content          = @"_content";
static NSString * const contact_countUnread      = @"_countUnread";
static NSString * const contact_timeStamp        = @"_timeStamp";
static NSString * const contact_isGroup          = @"_isGroup";
static NSString * const contact_isApp            = @"_isApp";
static NSString * const contact_lastMsgId        = @"_lastMsgId";
static NSString * const contact_lastMsg          = @"_lastMsg";
static NSString * const contact_info             = @"_info";
static NSString * const contact_muteNotification = @"_muteNotification";
static NSString * const contact_draft            = @"_draft";
static NSString * const contact_atMe             = @"_atMe";
static NSString * const contact_tag              = @"_tag";

@interface ContactDetailModel (SQLUtil)

+ (instancetype)sql_initWithResult:(FMResultSet *)result;

@end

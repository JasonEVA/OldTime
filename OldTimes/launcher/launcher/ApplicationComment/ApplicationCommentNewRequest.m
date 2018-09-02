//
//  ApplicationCommentNewRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplicationCommentNewRequest.h"
#import "ApplicationCommentModel.h"
#import <MJExtension.h>
static NSString * const d_appShowId      = @"appShowID";
static NSString * const d_messageAppType = @"messageAppType";
static NSString * const d_rmShowId       = @"rm_ShowID";
static NSString * const d_comment        = @"comment";
static NSString * const d_fileShowId     = @"fileShowID";
static NSString * const d_filePath       = @"filePath";
static NSString * const d_title          = @"Title";
static NSString * const d_toUsers        = @"toUsers";
static NSString * const d_toUserName     = @"toUserNames";
static NSString * const d_atWho     = @"atWho";

@implementation ApplicationCommentNewResponse
@end

@implementation ApplicationCommentNewRequest

+ (NSDictionary *)msgTypeDictionary {
    return @{
             @(ApplicationMsgType_approvalComment):@"APPROVAL_COMMENT",
             @(ApplicationMsgType_eventComment):@"EVENT_COMMENT",
             @(ApplicationMsgType_meetingComment):@"MEETING_COMMENT",
             @(ApplicationMsgType_taskComment):@"TASK_COMMENT"
             };
}

+ (NSString *)msgType:(ApplicationMsgType)type {
    return [[self msgTypeDictionary] objectForKey:@(type)];
}

- (instancetype)initWithDelegate:(id<BaseRequestDelegate>)delegate appShowID:(NSString *)appShowID commentType:(ApplicationMsgType)commentType {
    self = [super initWithDelegate:delegate];
    if (self) {
        self.params[d_appShowId]      = appShowID;
        self.params[d_messageAppType] = [ApplicationCommentNewRequest msgType:commentType];
    }
    return self;
}

- (NSString *)api  { return @"/Base-Module/Comment";}
- (NSString *)type { return @"PUT";}

- (void)setRmShowId:(NSString *)rmShowId {
    self.params[d_rmShowId] = rmShowId;
}

- (void)setToUser:(NSArray *)toUser toUserName:(NSArray *)toUserName title:(NSString *)title {
    self.params[d_toUsers] = toUser;
    self.params[d_toUserName] = toUserName;
    self.params[d_title] = title;
}
- (void)setAtWho:(NSString *)atWho {
	self.params[d_atWho] = atWho;
}

- (void)comment:(NSString *)comment {
    self.params[d_comment] = comment;
    [self.params removeObjectForKey:d_filePath];
    [self.params removeObjectForKey:d_fileShowId];
    [self requestData];
}

- (void)fileShowId:(NSString *)fileShowId filePath:(NSString *)filePath {
    self.params[d_fileShowId] = fileShowId;
    self.params[d_filePath]   = filePath;
    self.params[d_comment]    = @"iOS.png";
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    
    ApplicationCommentNewResponse *response = [ApplicationCommentNewResponse new];
    response.commentModel = [[ApplicationCommentModel alloc] initWithDict:data];
    return response;
}

@end

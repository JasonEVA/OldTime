//
//  ApplicationCommentNewRequest.h
//  launcher
//
//  Created by williamzhang on 15/11/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  应用评论新增request

#import "BaseRequest.h"

@class ApplicationCommentModel;

typedef NS_ENUM(NSUInteger, ApplicationMsgType) {
    ApplicationMsgType_eventComment,
    ApplicationMsgType_meetingComment,
    ApplicationMsgType_approvalComment,
    ApplicationMsgType_taskComment,
};

@interface ApplicationCommentNewResponse : BaseResponse

@property (nonatomic, strong) ApplicationCommentModel *commentModel;

@end

@interface ApplicationCommentNewRequest : BaseRequest

- (instancetype)initWithDelegate:(id<BaseRequestDelegate>)delegate appShowID:(NSString *)appShowID commentType:(ApplicationMsgType)commentType;

- (void)setToUser:(NSArray *)toUser toUserName:(NSArray *)toUserName title:(NSString *)title;
- (void)setRmShowId:(NSString *)rmShowId;

- (void)setAtWho:(NSString *)atWho;
/**
 *  新建评论
 *
 * 使用时先使用 setToUser:toUserName:title: & setRmShowId:若无变化，一次及可
 */
- (void)comment:(NSString *)comment;

/**
 *  新建附件
 *
 * 使用时先使用 setToUser:toUserName:title: & setRmShowId:若无变化，一次及可
 */
- (void)fileShowId:(NSString *)fileShowId filePath:(NSString *)filePath;

@end

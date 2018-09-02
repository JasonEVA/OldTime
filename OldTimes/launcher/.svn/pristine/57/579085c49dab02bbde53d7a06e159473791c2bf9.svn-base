//
//  ApplicationCommentBaseViewController.h
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  应用评论Base VC

#import "BaseViewController.h"
#import "MWPhotoBrowser.h"
#import "ApplicationCommentNewRequest.h"
#import "AttachmentUtil.h"

typedef enum{
    commentSelect_all = 0,
    commentSelect_Text = 1,
    commentSelect_Attachment = 2,
    commentSelect_System = 3,
    commentSelect_pic = 4,
    commentSelect_nil
}commentSelect;

@interface ApplicationCommentBaseViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, BaseRequestDelegate, UIActionSheetDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView *tableView;

/**
 *  应用showId
 */
@property (nonatomic, readonly) NSString *appShowId;

/**
 *  关联showId
 */
@property (nonatomic, copy) NSString *rmShowId;

/** 请子类自行初始化 */
@property (nonatomic, strong) ApplicationCommentNewRequest *createRequest;
@property (nonatomic) commentSelect commentstyle;
- (instancetype)initWithAppShowIdType:(AttachmentAppShowIdType)type rmShowID:(NSString *)rmShowID;

/**
 *  在发送评论时会自动使用，加入方法即可
 */
- (void)configCreateComment;

- (void)reloadComments;

- (void)changeCommentParameter;
- (void)setAllowAtUserMemberIDs:(NSArray *)memberIDs memeberNames:(NSArray *)memberNames;

@end

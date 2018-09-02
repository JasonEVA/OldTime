//
//  ChatAttachMgrViewController.h
//  Titans
//
//  Created by Remon Lv on 15/1/13.
//  Copyright (c) 2015年 Remon Lv. All rights reserved.
//  聊天附件下载VC

#import "BaseViewController.h"
#import <MintcodeIM/MintcodeIM.h>

@protocol ChatAttachMgrViewControllerDelegate <NSObject>

@required

/**
 *  下载完附件后发送的委托
 *
 *  @param fileUrl 附件沙盒地址
 */
- (void)ChatAttachMgrViewControllerDelegateCallBack_finishDownloadAndLookAttachWithFileUrl:(NSString *)fileUrl;

@end

@interface ChatAttachMgrViewController : BaseViewController <MessageManagerDelegate>
{
    MessageBaseModel *_baseModel;       // 附件数据
    ContactDetailModel *_contactModel;  // 附件数据
    
    UIImageView *_imgViewIcon;
    UILabel *_lbTitle, *_lbSize, *_lbText;
    UIButton *_btnDownload;
    UIProgressView *_viewProgress;          
}

@property (nonatomic,weak) id <ChatAttachMgrViewControllerDelegate> delegate;

/**
 *  初始化
 *
 *  @param baseModel 附件数据Model
 *  @param imgIcon   附件类型Icon
 *
 *  @return VC
 */
- (id)initWithBaseModel:(MessageBaseModel *)baseModel ContactModel:(ContactDetailModel *)contactModel;

@end

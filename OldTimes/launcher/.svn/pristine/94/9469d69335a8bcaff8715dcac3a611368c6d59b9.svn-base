//
//  ApplyCommentView.h
//  launcher
//
//  Created by Kyle He on 15/9/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactPersonDetailInformationModel.h"
@protocol ApplyCommentViewDelegate <NSObject>

@optional
- (void)ApplyCommentViewDelegateCallBack_SendTheTxt:(NSString *)text;
- (void)ApplyCommentViewDelegateCallBack_PresentAnotherVC;
- (void)ApplyCommentViewDelegateCallBack_CancleAction;

@end

typedef NS_ENUM(NSInteger, COMMENTSTATUS)
{
    kNoApprover = 0,
    kNextApprover =1,
    kAddApprover = 2,
    kotherKinds

};
@interface ApplyCommentView : UIView

/**
 *  评论状态：打回，却下，通过并转发
 */
@property(nonatomic, assign) COMMENTSTATUS  status;

@property(nonatomic, weak) id<ApplyCommentViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame withType:(COMMENTSTATUS)status;

- (void)setCommentViewStatus:(COMMENTSTATUS)status;

- (void)setHeadNameWithModel:(ContactPersonDetailInformationModel *)model;

- (void)showKeyBoard;

@end

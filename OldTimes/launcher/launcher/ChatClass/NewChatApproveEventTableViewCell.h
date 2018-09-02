//
//  NewChatApproveEventTableViewCell.h
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MintcodeIM/MintcodeIM.h>

@protocol NewChatApproveEventTableViewCellDelegate <NSObject>

@optional

- (void)approvalCellButtonClick:(NSString *)type path_row:(NSInteger)row;
- (void)approvalCellButtonClick:(NSString *)type path_row:(NSInteger)row isWorkFlow:(BOOL)workflow;

@end

@interface NewChatApproveEventTableViewCell : UITableViewCell
//代理
@property (nonatomic,weak) id<NewChatApproveEventTableViewCellDelegate> delegate;
// 记录当前行数
@property (nonatomic,assign) NSInteger  path_row;

- (void)setCellData:(MessageBaseModel *)model;

+ (CGFloat)cellHeightWithAppModel:(MessageAppModel *)content;

@end

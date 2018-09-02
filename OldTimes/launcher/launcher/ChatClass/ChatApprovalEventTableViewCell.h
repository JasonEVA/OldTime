
//
//  ChatApprovalEventTableViewCell.h
//  launcher
//
//  Created by TabLiu on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "EventSuperTableViewCell.h"

@protocol ChatApprovalEventTableViewCellDelegate <NSObject>

@optional

- (void)approvalCellButtonClick:(NSString *)type path_row:(NSInteger)row;
@end

@interface ChatApprovalEventTableViewCell : EventSuperTableViewCell

//代理
@property (nonatomic,weak) id<ChatApprovalEventTableViewCellDelegate> delegate;
// 记录当前行数
@property (nonatomic,assign) NSInteger  path_row;
// 行的高度
@property (nonatomic,assign) float  hight;

- (void)setCellData:(MessageBaseModel *)model;

@end

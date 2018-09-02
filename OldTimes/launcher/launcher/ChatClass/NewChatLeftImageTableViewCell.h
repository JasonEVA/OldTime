//
//  NewChatLeftImageTableViewController.h
//  launcher
//
//  Created by Lars Chen on 15/9/28.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatLeftBaseTableViewCell.h"

@interface NewChatLeftImageTableViewCell : ChatLeftBaseTableViewCell

/** 加载指示器关闭开启
 */
- (void)setImageLoading:(BOOL)loading;

- (void)showSendImageMessageBaseModel:(MessageBaseModel *)baseModel;

@end

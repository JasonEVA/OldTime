//
//  NewSiteMessageLeftImageTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信 左侧图片右侧文字 cell

#import "NewSiteMessageBubbleBaseTableViewCell.h"
#import "SiteMessageLastMsgModel.h"

@interface NewSiteMessageLeftImageTableViewCell : NewSiteMessageBubbleBaseTableViewCell
- (void)fillDataWithModel:(SiteMessageLastMsgModel *)model;
@end

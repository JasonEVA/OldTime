//
//  NewSiteMessageRoundsAlterView.h
//  HMClient
//
//  Created by jasonwang on 2017/1/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信 查房弹出框

#import <UIKit/UIKit.h>
#import "NewSiteMessageRoundsModel.h"

typedef void(^ButtonClick)(NSInteger tag);

@interface NewSiteMessageRoundsAlterView : UIView
//单例
+ (NewSiteMessageRoundsAlterView *)shareRoundsView;
//展示方法
- (void)showWithModel:(NewSiteMessageRoundsModel *)model btnClick:(ButtonClick)block;
//隐藏方法
- (void)closeClick;
@end

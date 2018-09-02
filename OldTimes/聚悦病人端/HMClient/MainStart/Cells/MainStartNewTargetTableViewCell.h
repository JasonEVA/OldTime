//
//  MainStartNewTargetTableViewCell.h
//  HMClient
//
//  Created by Andrew Shen on 2016/11/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//  目标cell

#import <UIKit/UIKit.h>

@class MainStartHealthTargetModel;

typedef void(^TargetValueClickedCompletion)(MainStartHealthTargetModel *model);
@interface MainStartNewTargetTableViewCell : UITableViewCell

- (void)configTargetItems:(NSArray<MainStartHealthTargetModel *> *)targetItems;
- (void)addTargetValueClickedCompletion:(TargetValueClickedCompletion)completion;
@end

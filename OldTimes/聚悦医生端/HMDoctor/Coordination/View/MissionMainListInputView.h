//
//  MissionMainListInputView.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskTypeTitleAndCountModel;

typedef void (^MissionMainListInputViewBlock)(TaskTypeTitleAndCountModel *selectModel);

@interface MissionMainListInputView : UIView

- (void)reloadInputViewWithData:(NSArray<TaskTypeTitleAndCountModel *> *)dataSource selectIndexBlock:(MissionMainListInputViewBlock)selectBlock;

- (void)closeInputViewNoti:(void(^)())closeView;
@end

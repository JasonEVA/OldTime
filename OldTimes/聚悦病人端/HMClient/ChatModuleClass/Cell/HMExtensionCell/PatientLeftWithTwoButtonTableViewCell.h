//
//  PatientLeftWithTwoButtonTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/9.
//  Copyright © 2016年 yinquan. All rights reserved.
//  医患聊天左侧卡片下部有两个按钮，暂时为预警

#import "ChatLeftBaseTableViewCell.h"
typedef void(^ButtonClick)(NSInteger tag);

@interface PatientLeftWithTwoButtonTableViewCell : ChatLeftBaseTableViewCell
- (void)fillInDataWith:(MessageBaseModel *)baseModel;
- (void)btnClick:(ButtonClick)block;
@end

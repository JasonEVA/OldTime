//
//  PatientDoubleChooseLeftTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/8/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//  左侧🔘单选框cell

#import "ChatLeftBaseTableViewCell.h"
typedef void(^ButtonClick)(NSInteger tag);

@interface PatientDoubleChooseLeftTableViewCell : ChatLeftBaseTableViewCell
- (void)fillInDataWith:(MessageBaseModel *)baseModel;
- (void)btnClick:(ButtonClick)block;

@end

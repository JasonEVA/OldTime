//
//  PatientHealthEducationRightTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2016/10/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  健康课堂右侧卡片

#import "ChatRightBaseTableViewCell.h"
@class IMNewsModel;

@interface PatientHealthEducationRightTableViewCell : ChatRightBaseTableViewCell
- (void)fillInDadaWith:(IMNewsModel *)model;

@end

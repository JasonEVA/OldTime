//
//  PatientHealthEducationLeftTableViewCell.h
//  HMClient
//
//  Created by jasonwang on 2016/10/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//  健康课堂左侧卡片

#import "ChatLeftBaseTableViewCell.h"
@class IMNewsModel;
@interface PatientHealthEducationLeftTableViewCell : ChatLeftBaseTableViewCell
- (void)fillInDadaWith:(IMNewsModel *)model;
@end

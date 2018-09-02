//
//  PatientEventTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/6/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChatLeftBaseTableViewCell.h"
#import "MessageBaseModel+CellSize.h"

@interface PatientEventTableViewCell : ChatLeftBaseTableViewCell
- (void)fillInDadaWith:(MessageBaseModel *)baseModel;

@end

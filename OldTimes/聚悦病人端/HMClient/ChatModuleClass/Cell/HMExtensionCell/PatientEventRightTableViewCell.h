//
//  PatientEventRightTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 16/6/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChatRightBaseTableViewCell.h"
#import "MessageBaseModel+CellSize.h"

@interface PatientEventRightTableViewCell : ChatRightBaseTableViewCell
- (void)fillInDadaWith:(MessageBaseModel *)baseModel;
@end

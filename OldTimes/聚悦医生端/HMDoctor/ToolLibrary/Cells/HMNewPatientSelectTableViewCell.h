//
//  HMNewPatientSelectTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2016/10/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//  新版病人选人cell

#import "PatientListTableViewCell.h"

@interface HMNewPatientSelectTableViewCell : PatientListTableViewCell
{
    UIImageView* ivSelected;
}
- (void) setIsSelected:(BOOL) selected;
@end

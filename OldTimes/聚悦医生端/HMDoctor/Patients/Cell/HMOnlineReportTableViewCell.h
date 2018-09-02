//
//  HMOnlineReportTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 2017/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdmissionAssessSummaryModel.h"
#import "HMThirdEditionPatitentDiagnoseModel.h"

@interface HMOnlineReportTableViewCell : UITableViewCell

- (void)setBfzResultListModel:(BfzResultListModel *)model;

@end

@interface HMDiagnoseReportTableViewCell : UITableViewCell

- (void)fillDiagnoseDataList:(NSArray *)dataList;

@end

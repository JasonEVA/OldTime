//
//  HMMedicalHistoryTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMOnlineArchivesModel.h"

@interface HMMedicalHistoryTableViewCell : UITableViewCell

@end

@interface HMHistoryIllnessTableViewCell : UITableViewCell

- (void)setHistoryIllnessNowInfo:(HMNowListModel *)info;
- (void)setHistoryIllnessBeforeInfo:(HMBeforListModel *)info;

@end

@interface HMBeforeHistoryTableViewCell : UITableViewCell

- (void)setHistoryIllnessBeforeInfo:(HMBeforListModel *)info;

@end

//
@interface HMFamilyHistoryTableViewCell : UITableViewCell

- (void)setFamilyHistoryInfo:(HMFamilyListModel *)info;

@end



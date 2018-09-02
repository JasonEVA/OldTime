//
//  HMAdmissionAssessDateView.h
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMOnlineArchivesModel.h"

@interface HMAdmissionAssessDateView : UIView

- (instancetype)initWithUserID:(NSString *)userID dateList:(NSArray *)dateList;

@property (nonatomic, copy) void(^dateSelectBlock)(HMAdmissionAssessDateListModel *model);
@end

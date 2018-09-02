//
//  PatientFilterTypeView.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatientListEnum.h"

typedef NS_ENUM(NSInteger, PatientFilterTag) {
    PatientFilterTagNone = -1,
    PatientFilterTagPackage,
    PatientFilterTagFree,
    PatientFilterTagGroup,
    PatientFilterTagSingle,
    PatientFilterTagFocus,
};

typedef void(^PatientFilterTagClickedHandler)(UIButton *item);
typedef void(^PatientFilterTimeRangeButtonClickedHandler)(NSInteger index);
@interface PatientFilterTypeView : UIView

- (instancetype)initWithPatientFilterViewType:(PatientFilterViewType)type;

- (void)addNotiForPatientTag:(PatientFilterTagClickedHandler)block;
- (void)addNotiForTimeRangeButton:(PatientFilterTimeRangeButtonClickedHandler)timeRangeBlock;
- (void)resetPatientTag:(PatientFilterTag)tag;
- (void)resetTimeRange;
- (void)configTimeRangeTime:(NSDate *)date index:(NSInteger)index;
@end

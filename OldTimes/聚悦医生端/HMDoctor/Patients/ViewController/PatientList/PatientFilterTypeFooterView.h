//
//  PatientFilterTypeFooterView.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//  筛选界面footerView

#import <UIKit/UIKit.h>

typedef void(^PatientFilterTypeFooterButtonClicked)(UIButton *button);
@interface PatientFilterTypeFooterView : UIView

- (void)addNotiForFilterTypeFooterButtonClicked:(PatientFilterTypeFooterButtonClicked)block;
@end

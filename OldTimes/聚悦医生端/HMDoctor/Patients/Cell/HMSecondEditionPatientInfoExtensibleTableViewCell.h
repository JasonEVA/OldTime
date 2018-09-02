//
//  HMSecondEditionPatientInfoExtensibleTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版患者信息页（免费版）可展开cell

#import <UIKit/UIKit.h>

typedef void(^extensibleCellClickBlock)();

@interface HMSecondEditionPatientInfoExtensibleTableViewCell : UITableViewCell
@property (nonatomic, strong) UIButton *extentBtn;
- (void)fillDataWithTitel:(NSString *)titel content:(NSString *)content showMutiLines:(BOOL)show;
- (void)extentClick:(extensibleCellClickBlock)block;
@end

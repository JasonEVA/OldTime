//
//  BloodPressureThreeDetectTableViewCell.h
//  HMClient
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressureThreeDetectTableViewCell : UITableViewCell

- (void)setDetectButtonTitle:(NSString *)str;
- (void)setDetectButtonHidden;

@end

@interface BloodPressureThriceDetectDataTableViewCell : UITableViewCell

- (void)setBloodPressureValue:(NSDictionary *)dic;

@end

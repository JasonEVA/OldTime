//
//  BloodPressureDetectSetUpTableViewCell.h
//  HMClient
//
//  Created by lkl on 2017/5/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressureDetectSetUpTableViewCell : UITableViewCell

- (void)setTitleContent:(NSString *)title;
- (void)setPromptContent:(NSString *)content color:(UIColor *)color;
@property (nonatomic, strong) UILabel *promptLabel;

@end

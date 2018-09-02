//
//  HMPramiseMeTableViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/15.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMPramiseMeModel;
@interface HMPramiseMeTableViewCell : UITableViewCell
- (void)fillDataWith:(HMPramiseMeModel *)model;

@end

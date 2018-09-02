//
//  HMFEPatientListGroupTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/10/18.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMPatientListGroupModel;
@interface HMFEPatientListGroupTableViewCell : UITableViewCell
- (void)fillDataWithModel:(HMPatientListGroupModel *)model selected:(BOOL)selected;
@end

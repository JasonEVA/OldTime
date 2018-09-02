//
//  SESearchTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoundsMessionModel;
@interface SESearchTableViewCell : UITableViewCell
- (void)fillDataWithModel:(RoundsMessionModel *)model;

@end

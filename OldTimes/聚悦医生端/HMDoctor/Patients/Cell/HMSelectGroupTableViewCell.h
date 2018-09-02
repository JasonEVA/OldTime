//
//  HMSelectGroupTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/6/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//  选择群组cell

#import <UIKit/UIKit.h>

@interface HMSelectGroupTableViewCell : UITableViewCell
- (void)fillDataWith:(NSString *)groupName count:(NSInteger)count isSelected:(BOOL) selected;
@end

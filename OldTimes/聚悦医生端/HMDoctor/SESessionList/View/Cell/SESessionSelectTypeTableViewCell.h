//
//  SESessionSelectTypeTableViewCell.h
//  HMDoctor
//
//  Created by jasonwang on 2017/9/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectedBlock)(BOOL selected);

@interface SESessionSelectTypeTableViewCell : UITableViewCell
- (void)fillDataWithTitelName:(NSString *)titelName unReadCount:(NSInteger)unReadCount isSelected:(BOOL)isSelected;

- (void)selectedClickBlock:(selectedBlock)block;
@end

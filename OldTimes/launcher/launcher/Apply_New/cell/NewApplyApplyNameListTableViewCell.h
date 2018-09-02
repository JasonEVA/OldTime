//
//  NewApplyApplyNameListTableViewCell.h
//  launcher
//
//  Created by conanma on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewApplyApplyNameListTableViewCell : UITableViewCell
@property (nonatomic) BOOL needmore;
@property (nonatomic, strong) UILabel *lblTitle;
- (void)setimgviewarrowHide;
- (void)setDataWithAllNameArr:(NSArray *)array needmorelines:(BOOL)needmorelines;
- (CGFloat)getHeight;
@end

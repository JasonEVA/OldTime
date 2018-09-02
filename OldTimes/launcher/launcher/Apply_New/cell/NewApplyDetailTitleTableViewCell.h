//
//  NewApplyDetailTitleTableViewCell.h
//  launcher
//
//  Created by conanma on 16/1/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyDetailInformationModel.h"

@interface NewApplyDetailTitleTableViewCell : UITableViewCell

- (void)setCCCellWithModel:(ApplyDetailInformationModel *)model;
- (void)setTitle:(NSString *)title;
- (CGFloat)getheight;

@end

//
//  NewApplyNameListWithArrowTableViewCell.h
//  launcher
//
//  Created by conanma on 16/1/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewApplyNameListWithArrowTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblTitle;

- (CGFloat)getHeight;
- (void)getdataWithArray:(NSMutableArray *)array;
- (void)getdataWithArray:(NSMutableArray *)array With:(NSString *)string;
@end

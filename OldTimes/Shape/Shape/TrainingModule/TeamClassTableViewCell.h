//
//  TeamClassTableViewCell.h
//  Shape
//
//  Created by Andrew Shen on 15/11/11.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//  团课课程cell

#import <UIKit/UIKit.h>

@class TeamClassModel;
@interface TeamClassTableViewCell : UITableViewCell

- (void)setClassData:(TeamClassModel *)model;
@end

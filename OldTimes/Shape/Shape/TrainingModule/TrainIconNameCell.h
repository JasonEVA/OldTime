//
//  TrainIconNameCell.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainGetDayTrainInfoModel.h"

@interface TrainIconNameCell : UITableViewCell
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *nameLb;

- (void)setMyData:(TrainGetDayTrainInfoModel *)model;
@end

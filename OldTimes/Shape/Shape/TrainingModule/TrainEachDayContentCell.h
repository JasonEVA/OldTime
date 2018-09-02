//
//  TrainEachDayContentCell.h
//  Shape
//
//  Created by jasonwang on 15/11/4.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrainGetTrainEachDayModel.h"

@interface TrainEachDayContentCell : UITableViewCell
@property (nonatomic, strong) UILabel *dayLb;
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *numLb;
@property (nonatomic, strong) UILabel *typeLb;
@property (nonatomic, strong) UIImageView *myimageViwe;

- (void)setMyData:(TrainGetTrainEachDayModel *)model day:(NSInteger)day;
@end

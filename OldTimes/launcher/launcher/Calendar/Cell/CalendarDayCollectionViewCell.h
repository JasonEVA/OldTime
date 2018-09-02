//
//  CalendarDayCollectionViewCell.h
//  launcher
//
//  Created by Conan Ma on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDateDataModel.h"

@interface CalendarDayCollectionViewCell : UICollectionViewCell
@property (nonatomic) NSInteger Weekday;
@property (nonatomic) BOOL IsSelected;
@property (nonatomic) BOOL Istoday;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIImageView *ImgView;

- (void)setModel:(CalendarDateDataModel *)model;
@end

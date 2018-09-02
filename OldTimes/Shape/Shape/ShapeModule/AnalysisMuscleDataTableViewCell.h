//
//  AnalysisMuscleDataTableViewCell.h
//  Shape
//
//  Created by Andrew Shen on 15/11/2.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MuscleModel;
@interface AnalysisMuscleDataTableViewCell : UITableViewCell
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)setCellData:(MuscleModel *)model totalTrainingTimes:(NSInteger)totalTimes;
@end

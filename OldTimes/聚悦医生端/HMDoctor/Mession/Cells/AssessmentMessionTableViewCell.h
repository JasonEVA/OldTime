//
//  AssessmentMessionTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssessmentMessionModel.h"

@interface AssessmentMessionTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UIButton* summaryButton;

- (void) setAssessmentMession:(AssessmentMessionModel*) messionModel;
@end

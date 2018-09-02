//
//  HealthPlanNutrionSelectSuggestionTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/25.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlanNutritionSuggestionModel : NSObject

@property (nonatomic, retain) NSString* suggestion;
@property (nonatomic, assign) BOOL isSelected;

@end



@interface HealthPlanNutrionSelectSuggestionTableViewCell : UITableViewCell

- (void) setHealthPlanDetCriteriaModel:(HealthPlanDetCriteriaModel*) model;
- (void) setIsSelected:(BOOL) isSelected;
@end

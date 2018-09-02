//
//  HealthPlanSportsTypeSelectView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/30.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthPlanSportsTypeSelectView : UIView

@property (nonatomic, strong) NSMutableArray* selectedSportsTyes;


- (void) setSelectedSportsTypes:(NSArray*) selectedSportsTyes
           unselectedSportsTyes:(NSArray*) unselectedSportsTyes;
@end

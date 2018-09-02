//
//  NutriationPlanTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/6/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NuritionDetail.h"

@interface NuritionInfo (PlanTableCellHeight)
{
    
}

- (CGFloat) cellHeight;
@end

@interface NutriationPlanTableViewCell : UITableViewCell
{
    
}
- (void) setNuritionSuggest:(NSString*) suggest;
@end

@interface NuritionPlanReaderTableViewCell : UITableViewCell
{
    
}
- (void) setTitle:(NSString *)title
          Content:(NSString*) content;
@end

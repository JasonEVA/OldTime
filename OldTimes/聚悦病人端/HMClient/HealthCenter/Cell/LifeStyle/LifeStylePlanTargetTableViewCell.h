//
//  LifeStylePlanTargetTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/6/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLifeStyleDetail.h"

@interface UserLifeStyleTarget (PlanTableCellHeight)
{
    
}

- (CGFloat) cellHeight;
@end

@interface LifeStylePlanTargetTableViewCell : UITableViewCell
{
    
}

- (void) setLifeStyleSuggest:(NSString*) suggest;
@end

@interface LifeStylePlanReaderTableViewCell : UITableViewCell
{
    
}

- (void) setTitle:(NSString *)title
          Content:(NSString*) content;
@end

//
//  StaffDetailDescTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/24.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StaffDetailDescTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UIButton* expendbutton;
- (void) setStaffDesc:(NSString*) teamdesc;
- (void) setExtendStyle:(NSInteger) style;
@end

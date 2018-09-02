//
//  DoctorTeamOrgDeptSelectView.h
//  HMClient
//
//  Created by yinqaun on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoctorTeamOrgDeptSelectCell : UIControl
{
    
}
- (void) setSelectedName:(NSString*) selectname;
@end

@interface DoctorTeamOrgDeptSelectView : UIView
{
    
}
@property (nonatomic, readonly) DoctorTeamOrgDeptSelectCell* orgSelectCell;
@property (nonatomic, readonly) DoctorTeamOrgDeptSelectCell* deptSelectCell;

@end

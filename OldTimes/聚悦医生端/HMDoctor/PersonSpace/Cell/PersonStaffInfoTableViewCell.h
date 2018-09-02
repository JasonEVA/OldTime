//
//  PersonStaffInfoTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonStaffInfoTableViewCell : UITableViewCell

@end

@interface PersonStaffPortraitTableViewCell : UITableViewCell

- (void) updateStaffInfo;

@end

@interface PersonStaffBaseInfoTableViewCell : UITableViewCell
{
    
}
- (void) setName:(NSString*) name Value:(NSString*) value;
@end

@interface PersonStaffHospitalInfoTableViewCell : UITableViewCell

- (void) setName:(NSString*) name Value:(NSString*) value;

@end

@interface PersonStaffDescriptionTableViewCell : UITableViewCell

- (void) setName:(NSString*) name Value:(NSString*) value;

@end


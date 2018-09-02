//
//  HMStaffInfoCollectionViewCell.h
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//  医生信息cell

#import <UIKit/UIKit.h>

@interface HMStaffInfoCollectionViewCell : UICollectionViewCell

- (void) setStaffInfo:(StaffInfo*) staff;
- (void) setIsTeamLeader:(BOOL) isLeader;
@end

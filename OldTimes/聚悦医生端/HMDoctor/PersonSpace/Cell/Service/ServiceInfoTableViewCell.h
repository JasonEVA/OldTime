//
//  ServiceInfoTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceInfoTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, retain) UIControl *scanButton;
- (void) setServiceInfo:(ServiceInfo*) service isGrade:(BOOL)isgrade;
@end

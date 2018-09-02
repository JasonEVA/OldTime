//
//  ServiceInfoTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceInfoTableViewCell : UITableViewCell
{
    
}

- (void) setServiceInfo:(ServiceInfo*) service isGrade:(BOOL)isgrade;
@end

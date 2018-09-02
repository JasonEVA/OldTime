//
//  ServiceOptionSelectTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/13.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceInfo.h"

@interface ServiceOptionSelectTableViewCell : UITableViewCell
{
    
}

- (void) setOption:(ServiceDetailOption*) option;
- (void) setOptionSelected:(BOOL) isSelected;
@end

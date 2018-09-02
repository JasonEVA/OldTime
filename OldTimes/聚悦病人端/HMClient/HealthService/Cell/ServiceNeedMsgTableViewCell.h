//
//  ServiceNeedMsgTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/16.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceNeedMsg.h"

@interface ServiceNeedMsgTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UITextField* tfValue;

- (void) setServiceNeedMsg:(ServiceNeedMsg*) needMsg;
@end

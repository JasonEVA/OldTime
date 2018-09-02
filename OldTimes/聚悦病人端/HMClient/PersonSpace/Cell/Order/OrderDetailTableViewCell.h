//
//  OrderDetailTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/17.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderInfo.h"

@interface OrderDetailTableViewCell : UITableViewCell
{
    
}

- (void) setOrderInfo:(OrderInfo*) order;
@end

@interface OrderDetailNameTableViewCell : UITableViewCell
{
    
}

- (void) setOrderName:(NSString*) orderName;
@end

@interface OrderDetailNumTableViewCell : UITableViewCell
{
    
}

- (void) setOrderNum:(NSInteger) orderNum;
@end

@interface OrderDetailAmountTableViewCell : UITableViewCell
{
    
}
- (void) setOrderAmount:(CGFloat) amount;
@end

@interface OrderDetailIntegalTableViewCell : UITableViewCell

- (void) setIntegal:(NSInteger) integal;
@end

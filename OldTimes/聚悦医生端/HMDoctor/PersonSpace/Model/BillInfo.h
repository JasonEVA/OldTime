//
//  BillInfo.h
//  HMDoctor
//
//  Created by lkl on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillInfo : NSObject

@property (nonatomic, retain) NSString *RECORD_ID;
@property (nonatomic, retain) NSString *PRODUCT_PARENT_NAME;
@property (nonatomic, retain) NSString *PRODUCT_NAME;
@property (nonatomic, retain) NSString *USER_NAME;
@property (nonatomic, retain) NSString *DIVIDE_MONEY;
@property (nonatomic, retain) NSString *DIVIDE_TIME;
@property (nonatomic, retain) NSString *LOGO;

@end

@interface BillTotalMoney : NSObject

@property (nonatomic, retain) NSString *estimatePrice;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSString *status;

@end

@interface BIllAccountSum : NSObject

@property (nonatomic, retain) NSString *accountSum;
@property (nonatomic, retain) NSString *versionNo;

@end
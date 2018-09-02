//
//  ServiceRecordInfo.h
//  HMDoctor
//
//  Created by yinqaun on 16/7/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceRecordInfo : NSObject
{
    
}

@property (nonatomic, retain) NSString* ORDER_TIME;
@property (nonatomic, assign) NSInteger BILL_WAY_NUM;
@property (nonatomic, retain) NSString* BILL_WAY_NAME;

@property (nonatomic, retain) NSString* USER_NAME;
@property (nonatomic, retain) NSString* PRODUCT_NAME;
@property (nonatomic, assign) NSInteger STATUS;
@property (nonatomic, retain) NSString* SEX;
@property (nonatomic, assign) NSInteger AGE;
@property (nonatomic, assign) BOOL physicalFlag;

@end

//
//  PersonDevicesItem.h
//  HMClient
//
//  Created by lkl on 2017/4/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonDevicesDetail : NSObject <NSCoding>

@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, copy) NSString *deviceIcon;
@property (nonatomic, copy) NSString *deviceNickName;

/*  deviceCode:
 0.血压计 鱼跃 XYJ_YY        优瑞恩  XYJ_YRN
 1.血糖仪 百捷 XTY_BJ        强生    XTY_QS
 2.心电仪 Hellofit XDY_HLF  好朋友  XDY_HPY
 */
@property (nonatomic, copy) NSString *deviceCode;
@property (nonatomic, assign) NSInteger isDefaultNum;

@end

@interface PersonDevicesItem : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *defaultName;
@property (nonatomic, copy) NSString *defaultIcon;
@property (nonatomic, copy) NSArray *devices;

@end

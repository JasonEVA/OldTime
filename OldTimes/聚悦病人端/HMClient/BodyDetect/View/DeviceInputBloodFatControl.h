//
//  DeviceInputBloodFatControl.h
//  HMClient
//
//  Created by lkl on 16/5/4.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceInputBloodFatControl : UIControl

@property (nonatomic, readonly) UITextField* tfValue;

- (void) setName:(NSString*) name SubName:(NSString*) subname;
@end

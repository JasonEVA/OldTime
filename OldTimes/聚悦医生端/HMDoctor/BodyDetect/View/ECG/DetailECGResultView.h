//
//  DetailECGResultView.h
//  HMClient
//
//  Created by lkl on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailECGResultView : UIView

- (void)setReslut:(NSString *)result;
- (void)setTestTime:(NSString *)testTime;
- (void)setHR:(NSString*)hr RR:(NSString*)rr QRS:(NSString*)qrs Result:(NSString*)result;

@end

//
//  UnifieldResultCodeManager.h
//  PalmDoctorDR
//
//  Created by Lars Chen on 15/4/15.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UnifiedResultCodeManager : NSObject<UIAlertViewDelegate>

+ (UnifiedResultCodeManager *)share;

/**
 *  返回码处理
 *
 *  @param resultCode 返回码
 *  @param msg 描述
 *  @return 是否是成功的
 */
- (BOOL)manageResultCode:(NSDictionary *)dictResult;
@end

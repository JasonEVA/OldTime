//
//  BloodSugarAddDietView.h
//  HMClient
//
//  Created by lkl on 2017/7/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BloodSugarDetectRecord.h"

@interface BloodSugarAddDietView : UIView

@end

//添加饮食情况
@interface BloodSugarAddDietControl : UIControl

- (void)isHasDietResult:(BOOL)isResult;

@end

//饮食情况结果
@interface BloodSugarDietResultView : UIView

- (void)setBloodSugarDetectResult:(BloodSugarDetectResult *)result;

@end


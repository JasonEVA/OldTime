//
//  ECGResultView.h
//  HMClient
//
//  Created by lkl on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeartRateDetectRecord.h"

@interface ECGResultView : UIView

@property(nonatomic,strong) UIButton *detailBtn;

- (void) setDetectResult:(HeartRateDetectResult*) result;

@end

//
//  BraceletScanView.h
//  HMClient
//
//  Created by lkl on 2017/9/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BraceletScanView : UIView

@property (nonatomic, strong) UILabel *scanLb;
@property (nonatomic, strong) UIButton *reScanBtn;

- (void)setBracelectViewWithImage:(NSString *)image promptMsg:(NSString *)msg;
@end



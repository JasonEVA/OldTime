//
//  BodyDetectManageViewController.h
//  HMClient
//
//  Created by lkl on 16/5/18.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "RecordHealthInfo.h"

//@interface CustomButton : UIButton
//
//@property (nonatomic, strong) UILabel *btnTitleLabel;
//@property (nonatomic, strong) UIImageView *imgView;
//
//@end

@interface CustomButton : UIControl

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imgView;

@end

@interface BodyDetectManageViewController : HMBasePageViewController

@property (nonatomic,strong) NSMutableArray *showDetectArray;
@property (nonatomic,strong) NSMutableArray *otherDetectArray;
@end

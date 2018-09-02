//
//  MeCodeView.h
//  launcher
//
//  Created by Conan Ma on 15/9/23.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactPersonDetailInformationModel.h"
@interface MeCodeView : UIView
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *imgHeader;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblID;
- (void)GetModel:(ContactPersonDetailInformationModel *)model;
@end

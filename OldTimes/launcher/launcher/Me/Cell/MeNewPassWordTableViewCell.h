//
//  MeNewPassWordTableViewCell.h
//  launcher
//
//  Created by Conan Ma on 15/9/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeNewPassWordTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *tfdNewPassWord;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnLowercase;   //小写
@property (nonatomic, strong) UIButton *btnUppercase;   //大写
@property (nonatomic, strong) UIButton *btnNumber;      //数字
@property (nonatomic, strong) UIButton *btnSpecialcase;    //特殊符号
@property (nonatomic, strong) UIButton *btnMorethaneight; //至少8位
@end

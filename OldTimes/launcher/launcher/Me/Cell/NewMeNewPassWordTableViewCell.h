//
//  NewMeNewPassWordTableViewCell.h
//  launcher
//
//  Created by 马晓波 on 16/3/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    SecurityType_None = 0,
    SecurityType_Low,
    SecurityType_Middle,
    SecurityType_High
}SecurityType;

@interface NewMeNewPassWordTableViewCell : UITableViewCell
@property (nonatomic, strong) UITextField *tfdNewPassWord;
@property (nonatomic, strong) UILabel *lblTitle;
- (void)SetSecurityType:(SecurityType)type;
//@property (nonatomic, strong) UIButton *btnLowercase;   //小写
//@property (nonatomic, strong) UIButton *btnUppercase;   //大写
//@property (nonatomic, strong) UIButton *btnNumber;      //数字
//@property (nonatomic, strong) UIButton *btnSpecialcase;    //特殊符号
//@property (nonatomic, strong) UIButton *btnMorethaneight; //至少8位
@end

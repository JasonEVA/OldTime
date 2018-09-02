//
//  TaskOnlyTextFieldTableViewCell.h
//  launcher
//
//  Created by Conan Ma on 15/8/29.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskOnlyTextFieldTableViewCell : UITableViewCell

+ (NSString *)identifier;

@property (nonatomic, strong) UITextField *texfFieldTitle;

@end

//
//  MeetingTimeDetailViewController.h
//  launcher
//
//  Created by 马晓波 on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"

@interface MeetingTimeDetailViewController :BaseViewController

@property (nonatomic, strong) NSString *required;
@property (nonatomic, strong) NSString *requiredName;

-(instancetype)initWithDate:(NSDate *)date;

@end

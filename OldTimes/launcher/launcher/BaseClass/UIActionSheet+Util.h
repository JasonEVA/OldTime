//
//  UIActionSheet+Util.h
//  launcher
//
//  Created by williamzhang on 15/10/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Util)

/**
 *  tag用作其他用途时用来区分的状态
 */
@property (nonatomic, assign) NSInteger identifier;

@end

@interface UIAlertView (Util)

@property (nonatomic, strong) NSString *identifier;

@end
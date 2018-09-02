//
//  ApplicationRemainTableViewCell.h
//  launcher
//
//  Created by williamzhang on 15/11/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplicationRemainTableViewCell : UITableViewCell

+ (NSString *)identifier;

- (void)hasRemain:(BOOL)remain;

@end

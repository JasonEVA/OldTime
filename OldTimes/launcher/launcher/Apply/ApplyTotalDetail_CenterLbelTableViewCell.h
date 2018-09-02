//
//  ApplyTotalDetail_CenterLbelTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/8/17.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  中间有label的cell

#import <UIKit/UIKit.h>

@interface ApplyTotalDetail_CenterLbelTableViewCell : UITableViewCell

/**
 *  名字
 */
@property(nonatomic, copy) NSString  *itemName;
/**
 *  标题
 */
@property(nonatomic, copy) NSString  *detailText ;

+(NSString *)identifier;

@end

//
//  NewApplyTotalDetail_RightTableViewCell.h
//  launcher
//
//  Created by conanma on 16/1/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewApplyTotalDetail_RightTableViewCell : UITableViewCell
/**
 *  左侧项目
 */
@property(nonatomic, copy) NSString  *itemName;
/**
 *  右侧详细文本
 */
@property(nonatomic, copy) NSString  *detailText;

+(NSString *)identifier;
@end

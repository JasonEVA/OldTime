//
//  PersonCommentTableViewCell.h
//  HMClient
//
//  Created by Dee on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//   用户评价cell

#import <UIKit/UIKit.h>

typedef void(^commentStarCountCallBackBlock)(NSInteger starCount);
@interface PersonCommentTableViewCell : UITableViewCell

+ (NSString *)identifier;

- (void)getStarCountWithBlock:(commentStarCountCallBackBlock)blcok;

@end

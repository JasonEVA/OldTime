//
//  ApplicationCommentFileCell.h
//  launcher
//
//  Created by Simon on 16/7/6.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApplicationCommentModel;

@interface ApplicationCommentFileCell : UITableViewCell
- (void)dataWithModel:(ApplicationCommentModel *)model;
- (void)clickToSee:(void(^)(id))clickBlock;
+ (CGFloat)getHeight;
@end

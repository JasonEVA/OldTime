//
//  NewApplyCommentTableViewCell.h
//  launcher
//
//  Created by conanma on 16/1/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplicationCommentModel.h"

typedef enum{
    CellKind_System,
    CellKind_Comment,
    CellKind_Attachement
}CellKind;

@interface NewApplyCommentTableViewCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellKind:(CellKind)kind;
- (void)dataWithModel:(ApplicationCommentModel *)model;
- (CGFloat)getHeight;
+ (CGFloat)cellHeightWithCommentModel:(ApplicationCommentModel *)model;

@end

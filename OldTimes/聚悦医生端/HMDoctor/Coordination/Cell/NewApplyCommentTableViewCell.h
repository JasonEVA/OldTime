//
//  NewApplyCommentTableViewCell.h
//  launcher
//
//  Created by conanma on 16/1/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  评论Cell

#import <UIKit/UIKit.h>
//#import "ApplicationCommentModel.h"

@class MissionCommentsModel;

typedef enum{
    CellKind_System,
    CellKind_Comment,
    CellKind_Attachement
}CellKind;

@interface NewApplyCommentTableViewCell : UITableViewCell

+ (NSString *)identifier;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier CellKind:(CellKind)kind;

- (CGFloat)getHeight;

- (void)configCommentModel:(MissionCommentsModel *)model;
@end

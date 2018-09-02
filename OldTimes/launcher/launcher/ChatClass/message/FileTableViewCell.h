//
//  FileTableViewCell.h
//  launcher
//
//  Created by Jason Wang on 15/9/21.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPoint.h"
#import <MintcodeIM/MintcodeIM.h>
#import "AvatarUtil.h"

@interface FileTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconView;    //头像框
@property (nonatomic, strong) RedPoint *redPoint;       //是否已读标示

@property (nonatomic,strong) NSString * uid;

@property (nonatomic,assign) BOOL  isGroup;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Action:(SEL)Action;

- (void)setCellData:(MessageBaseModel *)model searchText:(NSString *)text;
- (void)setMessageData:(MessageBaseModel *)model;


@end

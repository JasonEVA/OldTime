//
//  ApplyNameRightTableViewCell.h
//  launcher
//
//  Created by Kyle He on 15/9/7.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
@protocol ApplyNameRightTableViewCellDelegate <NSObject>

- (void)ApplyNameRightTableViewCellDelegateCallBack_moreClick:(NSIndexPath *)indexPath;

@end

@interface ApplyNameRightTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *myTextLabel;     //必须参加 label
@property (nonatomic, strong) MyLableWithAlignmentTop *myDetailLabel;   //人名label
@property (nonatomic) BOOL isMore;   //是否展开全部人名
@property (nonatomic) BOOL isEdit;   //是否可编辑   可编辑状态不添加更多点击手势
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, weak) id <ApplyNameRightTableViewCellDelegate> delegate;

- (void)setMyIsEdit:(BOOL)isEdit;
- (void)setMyIndexPath:(NSIndexPath *)indexPath;

+ (NSString *)identifier ;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setDataWithNameArr:(NSArray *)array;

- (void)setNameField:(NSString *)str;

@end

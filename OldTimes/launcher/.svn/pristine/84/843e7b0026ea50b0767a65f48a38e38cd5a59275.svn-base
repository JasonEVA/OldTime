//
//  NewApplyNameRightTableViewCell.h
//  launcher
//
//  Created by Dee on 16/8/11.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@protocol NewApplyNameRightTableViewCellDelegate <NSObject>

- (void)ApplyNameRightTableViewCellDelegateCallBack_moreClick:(NSIndexPath *)indexPath;

@end


@interface NewApplyNameRightTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel  *myTextLabel;

@property(nonatomic, strong) MyLableWithAlignmentTop  *myDetailLabel;

@property (nonatomic) BOOL isMore;   //是否展开全部人名
@property (nonatomic) BOOL isEdit;   //是否可编辑   可编辑状态不添加更多点击手势

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, weak) id <NewApplyNameRightTableViewCellDelegate> delegate;

- (void)setMyIsEdit:(BOOL)isEdit;
- (void)setMyIndexPath:(NSIndexPath *)indexPath;

+ (NSString *)identifier ;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setDataWithNameArr:(NSArray *)array;

- (void)setNameField:(NSString *)str;

@end

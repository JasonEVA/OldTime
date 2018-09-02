//
//  HMAssistIndicesDetailTableViewCell.h
//  HMDoctor
//
//  Created by lkl on 2017/7/11.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMGetCheckImgListModel.h"

@interface HMAssistIndicesDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

- (void)setAssistDetail:(CheckItemDetailModel *)detailModel index:(NSInteger)index;

@end


@interface HMAssistDetailImgTableViewCell : UITableViewCell

- (void)setDetailImageUrl:(NSString *)imgUrl;

@property (nonatomic, weak) UIViewController *ownerViewController;

@end

@interface HMAssistDetailGridTableViewCell : UITableViewCell

- (void)setDetailGridArray:(NSArray *)array;

@end

@interface HMAssistDetailItemTableViewCell : UITableViewCell

- (void)setCheckIteminsepecJsonDetail:(CheckIteminsepecJsonDetailModel *)model;

+ (CGFloat)textHeight:(NSString *)text;
+ (CGFloat)cellHegith:(CheckIteminsepecJsonDetailModel *)model;
@end

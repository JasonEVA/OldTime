//
//  ATStaticHeadView.h
//  Clock
//
//  Created by Dariel on 16/7/20.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ATStaticHeadViewDelegate <NSObject>

@optional
- (void)changeDate:(UILabel *)dateLabel isAddMouth:(BOOL) isAdd nextButton:(UIButton *)nextButton;

@end


@interface ATStaticHeadView : UIView

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, weak) id<ATStaticHeadViewDelegate> delegate;

@property (nonatomic, strong) UILabel *normalLabelNum;
@property (nonatomic, strong) UILabel *unnormalLabelNum;

@end


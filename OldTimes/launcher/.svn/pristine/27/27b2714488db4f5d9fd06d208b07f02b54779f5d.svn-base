//
//  NewApplyTextViewCell.h
//  launcher
//
//  Created by Dee on 16/8/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  标题和备注等输入框 Form_inputType_textArea

#import <UIKit/UIKit.h>
@class NewApplyFormBaseModel;
typedef void(^textViewLocaionCallBack) (CGRect currentRect);
@interface NewApplyTextViewCell : UITableViewCell

+ (NSString *)identifier;

- (void)setDataWithModel:(NewApplyFormBaseModel *)model;

- (void)getLocationWithBlock:(textViewLocaionCallBack)block;

@end

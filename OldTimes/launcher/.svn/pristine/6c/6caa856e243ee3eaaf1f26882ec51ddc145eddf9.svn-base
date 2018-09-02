//
//  NewApplyRecordTableViewCell.h
//  launcher
//
//  Created by conanma on 16/1/21.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextConfigure.h"

@protocol NewApplyRecordTableViewCellDelegate <NSObject>
- (void)newApplyRecordTableViewCellDidClickRichText:(NSString *)text textType:(RichTextType)textType;
@end

@interface NewApplyRecordTableViewCell : UITableViewCell

@property (nonatomic, readonly) UILabel *lblTitle;
@property (nonatomic, assign)id<NewApplyRecordTableViewCellDelegate> delegate;

+ (NSString *)identifier;
+ (CGFloat)heightForCell:(NSString *)text;

- (void)setDetailText:(NSString *)detailText;

@end

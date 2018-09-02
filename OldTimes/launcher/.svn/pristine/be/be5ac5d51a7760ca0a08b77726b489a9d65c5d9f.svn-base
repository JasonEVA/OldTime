//
//  ContactBookNameTableViewCell.h
//  launcher
//
//  Created by kylehe on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactPersonDetailInformationModel;

@interface ContactBookNameTableViewCell : UITableViewCell
@property (nonatomic) BOOL isMission;
+ (NSString *)identifier;
+ (CGFloat)height;

- (void)setSearchText:(NSString *)searchText;

- (void)setDataWithModel:(ContactPersonDetailInformationModel *)model ;
- (void)setDataWithModel:(ContactPersonDetailInformationModel *)model selectMode:(BOOL)selectMode;

- (void)setSelect:(BOOL)isSelected unableSelect:(BOOL)unableSelect selfSelectable:(BOOL)selfSelectable;

@end

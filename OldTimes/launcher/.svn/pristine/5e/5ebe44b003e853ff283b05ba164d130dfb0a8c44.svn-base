//
//  ContactBookDeptTableViewCell.h
//  launcher
//
//  Created by kylehe on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactDepartmentImformationModel.h"

@protocol ContactBookDeptTableViewCellDelegate  <NSObject>

- (void)ContactBookDeptTableViewCell_AddDepartWithModel:(ContactDepartmentImformationModel *)model;

- (void)ContactBookDeptTableViewCell_DeletePartWithModel:(ContactDepartmentImformationModel *)model;

@end

@interface ContactBookDeptTableViewCell : UITableViewCell
+ (NSString *)identifier;
+ (CGFloat)height;

- (void)setDataWithDeptModel:(ContactDepartmentImformationModel *)model;
- (void)setDataWithDeptModel:(ContactDepartmentImformationModel *)model selectMode:(BOOL)selectMode;

- (void)clickToSelect:(void (^)(id cell))selectBlock;
- (void)isSingleMode;
- (void)setSearchText:(NSString *)searchText;

@end

//
//  RoundsTemplateTableViewCell.h
//  HMDoctor
//
//  Created by yinquan on 16/9/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundsTemplateModel.h"

@interface RoundsTemplateTableViewCell : UITableViewCell

- (void) setRoundsTemplateModel:(RoundsTemplateModel*) templateModel;
@end

@interface RoundsTemplateCategoryTableViewCell : UITableViewCell

- (void) setRoundsTemplateCategoryModel:(RoundsTemplateCategoryModel*) category;
@end


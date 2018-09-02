//
//  CreateDocumentMessionTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateDocumetnMessionInfo.h"

@interface CreateDocumentMessionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton* viewButton;       //查看按钮
- (void) setCreateDocumentMession:(CreateDocumetnMessionInfo*)mession;
@end

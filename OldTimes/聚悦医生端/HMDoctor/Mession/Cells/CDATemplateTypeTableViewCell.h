//
//  CDATemplateTypeTableViewCell.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateDocumetnMessionInfo.h"

@interface CDATemplateTypeTableViewCell : UITableViewCell
{
    
}
@property (nonatomic, readonly) UILabel* templateLable;
- (void) setCreateDocumetnTemplateTypeModel:(CreateDocumetnTemplateTypeModel*) typeModel;
@end

//尚未评估的模版
@interface CDAUnAssessedTemplateTypeTableViewCell : CDATemplateTypeTableViewCell
{
    
}
@end

/*
 已经评估的模版
 */
@interface CDAAssessedTemplateTypeTableViewCell : CDATemplateTypeTableViewCell
{
    
}
@end

#import "PlaceholderTextView.h"
@interface CDATemplateDiagnosisTableViewCell : UITableViewCell
{
    
}

@property (nonatomic, readonly) UILabel* diagnosisLable;
- (void) setCreateDocumetnTemplateTypeModel:(CreateDocumetnTemplateTypeModel*) typeModel;

@end

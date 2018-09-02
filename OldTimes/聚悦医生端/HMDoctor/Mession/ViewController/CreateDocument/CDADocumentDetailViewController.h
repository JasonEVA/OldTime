//
//  CDADocumentDetailViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/25.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMBasePageViewController.h"
#import "CreateDocumetnMessionInfo.h"

@interface CDADocumentDetailViewController : HMBasePageViewController

@property (nonatomic, readonly) CreateDocumetnTemplateTypeModel* templateTypeModel;
@property (nonatomic, assign) NSInteger status;


@end

@interface CDAFillAssessmentDocumentDetailViewController : CDADocumentDetailViewController

@end

@interface CDAFilledAssessmentDocumentDetailViewController : CDADocumentDetailViewController

@end
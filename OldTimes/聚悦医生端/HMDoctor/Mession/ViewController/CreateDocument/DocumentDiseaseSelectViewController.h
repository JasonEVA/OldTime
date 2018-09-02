//
//  DocumentDiseaseSelectViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateDocumetnMessionInfo.h"

typedef void(^DocumentDiseaseSelectedBlock)(BOOL selected, CreateDocumetnTemplateModel* templateModel);

@interface DocumentDiseaseSelectViewController : UIViewController

+ (void) showInParentController:(UIViewController*) parentController
                   messionModel:(CreateDocumetnMessionInfo*) messionModel
                  selectedBlock:(DocumentDiseaseSelectedBlock) block;
@end

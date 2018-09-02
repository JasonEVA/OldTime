//
//  CreateDocumentAssessmentContentViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateDocumentAssessmentContentViewController : UIViewController

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger staffUserId;

- (id) initWithAssessmentReportId:(NSString*) assessmentReportId
                       templateId:(NSString*) templateId
                           status:(NSInteger) status;

- (void) setAssessmentTemplateId:(NSString*) templateId
                          status:(NSInteger) status;


@end

//
//  CDAPersonInfoViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDADocumentInfoViewController : UIViewController

@property (nonatomic, readonly) NSString* assessmentReportId;
@property (nonatomic, readonly) NSString* templateId;

- (id) initWithAssessmentReportId:(NSString*) assessmentReportId
                       templateId:(NSString*) templateId;

- (void) setTemplateId:(NSString*) templateId;
@end

/*
 建档评估－个人信息
 */
@interface CDAPersonInfoViewController : CDADocumentInfoViewController

@end

/*
 建档评估－检验检查信息
 */
@interface CDAExamineViewController : CDADocumentInfoViewController

@end

/*
 建档评估－病史信息
 */
@interface CDAMedicalHistoryViewController : CDADocumentInfoViewController

@end

/*
 建档评估－用药情况
 */
@interface CDAMedicationViewController : CDADocumentInfoViewController

@end

@interface CDAAssessmentReportDetailViewController : CDADocumentInfoViewController

@end



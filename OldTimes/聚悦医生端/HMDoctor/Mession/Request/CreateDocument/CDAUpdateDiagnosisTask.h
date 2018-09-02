//
//  CDAUpdateDiagnosisTask.h
//  HMDoctor
//
//  Created by yinqaun on 16/8/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SingleHttpRequestTask.h"

/*
 更新建档评估的诊断
 */
@interface CDAUpdateDiagnosisTask : SingleHttpRequestTask

@end

/*
 提交评估报告给医生
 */
@interface CDASendAssessmentToDoctorTask : SingleHttpRequestTask

@end

/*
 医生生成报告
 */

@interface CDABuildAssessmentReportTask : SingleHttpRequestTask

@end
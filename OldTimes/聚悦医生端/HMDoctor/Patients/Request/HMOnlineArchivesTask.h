//
//  HMOnlineArchivesTask.h
//  HMDoctor
//
//  Created by lkl on 2017/3/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "SingleHttpRequestTask.h"

@interface HMOnlineArchivesTask : SingleHttpRequestTask

@end

@interface getAdmissionAssessDateListTask : SingleHttpRequestTask

@end

//入院记录病史信息
@interface getJbHistoryListTask : SingleHttpRequestTask

@end


//疾病风险评估概览
@interface getAdmissionAssessSummaryTask : SingleHttpRequestTask

@end

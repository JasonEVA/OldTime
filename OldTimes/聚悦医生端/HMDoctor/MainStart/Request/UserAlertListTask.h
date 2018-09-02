//
//  UserAlertListTask.h
//  HMDoctor
//
//  Created by yinqaun on 16/6/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SingleHttpRequestTask.h"

@interface UserAlertListTask : SingleHttpRequestTask

@end

@interface DealUserAlertTask : SingleHttpRequestTask

@end

@interface UserAlertCountTask : SingleHttpRequestTask

@end

@interface DealWarningTask : SingleHttpRequestTask

@end

//预警处理-联系患者
@interface DoContactPatientTask : SingleHttpRequestTask

@end

//获取一条预警信息
@interface GetWarningDetTask : SingleHttpRequestTask

@end

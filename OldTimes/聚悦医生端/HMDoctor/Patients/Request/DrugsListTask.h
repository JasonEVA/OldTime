//
//  DrugsListTask.h
//  HMDoctor
//
//  Created by lkl on 16/6/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SingleHttpRequestTask.h"

@interface DrugsListTask : SingleHttpRequestTask
@end


@interface SearchDrugsTask : SingleHttpRequestTask

@end

//用药频率列表
@interface DrugsUsageListTask : SingleHttpRequestTask

@end

//用药用法
@interface DrugsFrequencyListTask : SingleHttpRequestTask

@end

//剂量单位
@interface DrugUnitListTask : SingleHttpRequestTask

@end


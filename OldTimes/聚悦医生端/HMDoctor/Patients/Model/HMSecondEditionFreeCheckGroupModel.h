//
//  HMSecondEditionFreeCheckGroupModel.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSecondEditionFreePatientInfoCheckModel.h"

@interface HMSecondEditionFreeCheckGroupModel : NSObject
@property (nonatomic, copy) NSString *groupName;  //血常规
@property (nonatomic, copy) NSArray <HMSecondEditionFreePatientInfoCheckModel* >*groupData;   //图片数组
@end

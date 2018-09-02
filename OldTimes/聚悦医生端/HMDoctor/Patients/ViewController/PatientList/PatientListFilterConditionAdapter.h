//
//  PatientListFilterConditionAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATTableViewAdapter.h"

@interface PatientListFilterConditionAdapter : ATTableViewAdapter

- (void)reloadData:(NSArray *)array selectedTitle:(NSString *)selectedTitle footerView:(UIView *)footerView;
@end

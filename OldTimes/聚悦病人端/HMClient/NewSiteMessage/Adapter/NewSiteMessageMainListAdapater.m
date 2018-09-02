//
//  NewSiteMessageMainListAdapater.m
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageMainListAdapater.h"
#import "NewSiteMessageMainListTableViewCell.h"
#import "SiteMessageSecondEditionMainListModel.h"

@implementation NewSiteMessageMainListAdapater
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSiteMessageSecondEditionMainListModel:(SiteMessageSecondEditionMainListModel *)model {
    NewSiteMessageMainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageMainListTableViewCell at_identifier]];
    [cell fillDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000000001;
}

@end

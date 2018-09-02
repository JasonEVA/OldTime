//
//  CoordinationSearchResultAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CoordinationSearchResultAdapter.h"
#import "ContactDoctorInfoTableViewCell.h"
#import "DoctorContactDetailModel.h"
#import "CoordinationSearchResultViewController.h"
#import "NewPatientListInfoModel.h"
#import "PatientListTableViewCell.h"

@implementation CoordinationSearchResultAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.adapterArray[section] count] > 0) {
    return 25;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.adapterArray[section] count] > 0) {
        return 15;
    }
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.adapterArray[indexPath.section] lastObject] isKindOfClass:[moreModel class]] && indexPath.row == 3) {
        return 40;
    }
    else {
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMessageRelationInfoModel:(MessageRelationInfoModel *)model {
    ContactDoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
    [cell fillDataWithMessageRelationInfoModel:model searchText:self.searchText];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForMessageBaseModel:(MessageBaseModel *)model {
    ContactDoctorInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ContactDoctorInfoTableViewCell at_identifier]];
    [cell fillDataWithMessageBaseModel:model searchText:self.searchText];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNewPatientListInfoModel:(NewPatientListInfoModel *)model {
    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientListTableViewCell at_identifier]];
    [cell configCellDataWithNewPatientListInfoModel:model filterKeywords:self.searchText];
    // 搜索结果不显示金额
    [cell.orderMoney setHidden:YES];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellFormoreModel:(moreModel *)model {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defultCell"];
    [cell.imageView setImage:[UIImage imageNamed:@"chat_searchIcon"]];
    [cell.textLabel setText:model.contentStr];
    [cell.textLabel setFont:[UIFont font_26]];
    [cell.textLabel setTextColor:[UIColor commonLightGrayColor_999999]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [UIView new];
    [headView setBackgroundColor:[UIColor whiteColor]];
    if ([self.adapterArray[section] count] > 0) {
        UILabel *textLb = [UILabel new];
        [textLb setFont:[UIFont systemFontOfSize:13]];
        [textLb setTextColor:[UIColor commonLightGrayColor_999999]];
        [headView addSubview:textLb];
        
        [textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView);
            make.left.equalTo(headView).offset(12.5);
        }];
        [textLb setText:self.headerTitles[section]];
    }
    
    return headView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end

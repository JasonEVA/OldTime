//
//  PatientListFilterConditionAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientListFilterConditionAdapter.h"
#import "PatientListFilterConditionTableViewCell.h"
#import "PatientFilterTypeFooterView.h"

@interface PatientListFilterConditionAdapter ()
@property (nonatomic, strong)  NSString  *selectedTitle; // <##>
@property (nonatomic, weak)  UIView  *footerView; // <##>
@end
@implementation PatientListFilterConditionAdapter

- (void)reloadData:(NSArray *)array selectedTitle:(NSString *)selectedTitle footerView:(UIView *)footerView {
    [self.adapterArray removeAllObjects];
    [self.adapterArray addObjectsFromArray:array];
    self.selectedTitle = selectedTitle;
    _footerView = footerView;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientListFilterConditionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PatientListFilterConditionTableViewCell class]) forIndexPath:indexPath];
    [cell.textLabel setText:self.adapterArray[indexPath.row]];
    NSString *title = self.adapterArray[indexPath.row];
    cell.accessoryView.hidden = ![title isEqualToString:self.selectedTitle];
    cell.textLabel.textColor = [title isEqualToString:self.selectedTitle] ? [UIColor mainThemeColor] : [UIColor commonBlackTextColor_333333];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.footerView) {
        return 45;
    }
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

@end

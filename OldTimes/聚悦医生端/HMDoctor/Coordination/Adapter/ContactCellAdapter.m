//
//  ContactCellAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/16.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ContactCellAdapter.h"
#import "CoordinationContactTableViewCell.h"
#import "ContactInfoModel.h"
#import <MintcodeIMKit/MintcodeIMKit.h>
@implementation ContactCellAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section + 1 <= self.sectionTitles.count) {
        return 25;
    }
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section + 1 <= self.sectionTitles.count) {
        return self.sectionTitles[section];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForContactInfoModel:(ContactInfoModel *)model {
    CoordinationContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CoordinationContactTableViewCell class])];
    // 配置数据
    [cell configCellData:model selectable:self.selectable];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectable) {
        ContactInfoModel *model = self.adapterArray[indexPath.row];
        if (self.singleSelect) {
            if (!model.selected) {
                NSArray *arrayTemp = [self.adapterArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"selected == YES"]];
                if (arrayTemp.count > 0) {
                    ContactInfoModel *oldModel = arrayTemp.firstObject;
                    oldModel.selected = NO;
                }
            }
        }
        model.selected = !model.selected;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView reloadData];
//    CoordinationContactTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell selectCell:model.selected];
}
@end

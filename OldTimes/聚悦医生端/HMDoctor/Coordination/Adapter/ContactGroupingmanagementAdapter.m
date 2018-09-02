//
//  ContactGroupingmanagementAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ContactGroupingmanagementAdapter.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

@implementation ContactGroupingmanagementAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isDefault = YES"];
    id cellData;
    if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
        cellData = self.adapterArray[indexPath.section][indexPath.row];
    }
    else {
        cellData = self.adapterArray[indexPath.row];
    }
    if ([predicate evaluateWithObject:cellData]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id cellData;
        if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
            cellData = self.adapterArray[indexPath.section][indexPath.row];
        }
        else {
            cellData = self.adapterArray[indexPath.row];
        }
        if (self.adapterDelegate) {
            if ([self.adapterDelegate respondsToSelector:@selector(deleteCellData:indexPath:)]) {
                [self.adapterDelegate deleteCellData:cellData indexPath:indexPath];
            }
        }
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageRelationGroupModel *model = self.adapterArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
    [cell.textLabel setFont:[UIFont font_30]];
    [cell.textLabel setTextColor:[UIColor commonBlackTextColor_333333]];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([self.adapterArray.firstObject isKindOfClass:[NSArray class]]) {
        [cell.textLabel setText:self.adapterArray[indexPath.section][indexPath.row]];
    }
    else {
        [cell.textLabel setText:model.relationGroupName];
    }

    if (!self.managementStatus && model.relationGroupId == self.selectModel.relationGroupId) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    return cell;
}


@end

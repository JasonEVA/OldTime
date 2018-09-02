//
//  ATManagerClockAdapter.m
//  Clock
//
//  Created by SimonMiao on 16/7/21.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATManagerClockAdapter.h"
#import "ATManagerClockTimeCell.h"
#import "ATEmptyCell.h"

#import "ATCommonCellModel.h"

@implementation ATManagerClockAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = self.adapterArray[indexPath.row];
    if ([model isKindOfClass:[ATEmptyCellModel class]]) {
        return 20;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForATManagerClockTimeCellModel:(id)cellData {
    NSString *cellId = NSStringFromSelector(_cmd);
    ATManagerClockTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ATManagerClockTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell addfooterLineWithColor:[UIColor at_lightGrayColor] lineX:15];
    }
    
    [cell updateCellWithData:cellData hideHeaderLine:YES hideFooterLine:YES];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForATEmptyCellModel:(id)cellData
{
    NSString *cellId = NSStringFromSelector(_cmd);
    ATEmptyCell *cell = (ATEmptyCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ATEmptyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.contentView.backgroundColor = [UIColor at_lightGrayColor];
    }
    
    return cell;
}

@end

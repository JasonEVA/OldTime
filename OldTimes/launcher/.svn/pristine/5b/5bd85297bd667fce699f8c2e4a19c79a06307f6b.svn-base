//
//  ATDailyAttendanceAdapter.m
//  Clock
//
//  Created by SimonMiao on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATDailyAttendanceAdapter.h"
#import "ATCheckAttendanceViewCell.h"
#import "ATNoClockTitleCell.h"

//#import "ATNoClockTitleCellModel.h"
#import "ATPunchCardModel.h"
#import "UIColor+ATHex.h"

@implementation ATDailyAttendanceAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cellData = self.adapterArray[indexPath.row];
    if ([cellData isKindOfClass:[ATPunchCardModel class]]) {
        ATPunchCardModel *model = (ATPunchCardModel *)cellData;
        return model.cellHeight;
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForATPunchCardModel:(id)cellData {
    NSString *cellId = NSStringFromSelector(_cmd);
    ATCheckAttendanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ATCheckAttendanceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell cellOfEditingBtnClicked:^(ATPunchCardModel *model) {
            if (_block) {
                _block(model);
            }
        }];
    }
    ATPunchCardModel *model = (ATPunchCardModel *)cellData;
    [cell addfooterLineWithColor:[UIColor at_lightGrayColor] lineX:100 cellHeight:model.cellHeight];
    
    [cell updateCellWithData:cellData hideHeaderLine:YES hideFooterLine:YES];
    
    return cell;
}

//ATNoClockTitleCellModel
- (UITableViewCell *)tableView:(UITableView *)tableView cellForATNoClockTitleCellModel:(id)cellData {
    NSString *cellId = NSStringFromSelector(_cmd);
    ATNoClockTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ATNoClockTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addfooterLineWithColor:[UIColor at_lightGrayColor] lineX:100 cellHeight:44.0];
        
    }
    
    [cell updateCellWithData:cellData hideHeaderLine:YES hideFooterLine:YES];
    
    return cell;
}

- (void)goToEditingRemark:(ATDailyAttendanceAdapterBlock)block
{
    _block = block;
}

@end

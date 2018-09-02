//
//  ATCheckAttendanceViewAdapter.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATCheckAttendanceViewAdapter.h"
#import "ATCheckAttendanceViewCell.h"

#import "UIColor+ATHex.h"

@implementation ATCheckAttendanceViewAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 95.0;//65
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForATPunchCardModel:(id)cellData {
    NSString *cellId = NSStringFromSelector(_cmd);
    ATCheckAttendanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ATCheckAttendanceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addfooterLineWithColor:[UIColor at_lightGrayColor] lineX:100 cellHeight:95.0];
        
        [cell cellOfEditingBtnClicked:^(ATPunchCardModel *model) {
            if (_block) {
                _block(model);
            }
        }];
    }
    
    [cell updateCellWithData:cellData hideHeaderLine:YES hideFooterLine:YES];
    
    return cell;
}

- (void)goToEditingRemark:(ATCheckAttendanceViewAdapterBlock)block
{
    _block = block;
}

@end

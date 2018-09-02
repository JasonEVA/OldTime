//
//  ATStatisticsViewAdapter.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATStatisticsViewAdapter.h"
#import "ATStaticViewCell.h"

@interface  ATStatisticsViewAdapter()<ATStaticViewCellDelegate>

@property (assign, getter=isShowBg) BOOL isShowBg;


@end

@implementation ATStatisticsViewAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForATStaticModel:(id)cellData {
    NSString *cellId = NSStringFromSelector(_cmd);
    ATStaticViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[ATStaticViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    [cell updateCellWithData:cellData hideHeaderLine:YES hideFooterLine:YES];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATStaticViewCell *staticViewCell = (ATStaticViewCell *)cell;
    staticViewCell.delegate = self;

    if (indexPath.row%2 == 0) {
        staticViewCell.bgView.backgroundColor = [UIColor colorWithRed:226/255.0 green:245/255.0 blue:255/255.0 alpha:1];
    }else {
        staticViewCell.bgView.backgroundColor = [UIColor whiteColor];
    }
}



- (void)sendDateForRequest:(double)date staticViewCell:(ATStaticViewCell *)cell {

    if (self.delegate && [self.delegate respondsToSelector:@selector(sendDateForRequest:staticViewCell:)]) {
        [self.delegate sendDateForRequest:date staticViewCell:cell];
    }

}



@end

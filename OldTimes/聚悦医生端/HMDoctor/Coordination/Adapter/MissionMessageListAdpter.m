
//
//  MissionMessageListAdpter.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionMessageListAdpter.h"
#import "MissionMessageCardCell.h"
#import "MissionSendFromMeMessageCardCell.h"
#import "MissionDetailModel.h"
#import "MissionRightMessageTableViewCell.h"
#import "MissionSystemMessageTableViewCell.h"
#define W_MINHEIGHT 95   //最小高度

@interface MissionMessageListAdpter()
@property (nonatomic, copy) MissionMessageListAdpterBlock block;
@end

static const CGFloat kCardCommentHeight = 135 + 20;  //评论卡片高度
static const CGFloat kCardNormalHeight = 190 + 13; //正常卡片高度
static const CGFloat kCardWithActionHeight = 243 ; //带操作按钮卡片高度
static const CGFloat kCardRefuseHeight = 210 + 20;    //拒绝卡片高度

@implementation MissionMessageListAdpter
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MissionDetailModel *model = self.adapterArray[indexPath.row];
    switch (model.eventType) {
        case CreateTask_Creater:
        case Accept_Creater:
        case Accept_Accepter:
        case Finish_Creater:
        case Finish_Accepter:
        case Expired_Creater:
        case Expired_Accepter: {
            return kCardNormalHeight;
            break;
        }
        case CreateTask_Accepter: {
            return kCardWithActionHeight;
            break;
        }
        case Refuse_Creater:
        case Refuse_Accepter: {
            return kCardRefuseHeight;
            break;
        }

        case k_comment: {
            return kCardCommentHeight;
            break;
        }
        case Notify: {
            return [self getRowHeightWithString:[self getAttributedStringWithString:model.msgInfo]];
            break;
        }
    }

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath withMissionDetailModel:(MissionDetailModel *)model
{
    id cell = nil;
    switch (model.eventType) {
        case CreateTask_Creater: {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionRightMessageTableViewCell at_identifier]];
            if (!cell) {
                cell = [[MissionRightMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionRightMessageTableViewCell at_identifier]];
            }
            
            [cell setCellDataWithModel:model];
            break;
        }
        case CreateTask_Accepter:
        case Accept_Creater:
        case Accept_Accepter:
        case Refuse_Creater:
        case Refuse_Accepter:
        case Finish_Creater:
        case Finish_Accepter:
        case Expired_Creater:
        case Expired_Accepter: {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionMessageCardCell at_identifier]];
            if (!cell) {
                cell = [[MissionMessageCardCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionMessageCardCell at_identifier]];
            }
            
            [cell setCellDataWithModel:model];
            __weak typeof(self) weakSelf = self;
            [cell clickBtnBlock:^(BOOL isAccept) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf.block) {
                    strongSelf.block(isAccept,indexPath.row);
                }
            }];

            break;
        }
        case k_comment: {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionSendFromMeMessageCardCell at_identifier]];
            if (!cell) {
                cell = [[MissionSendFromMeMessageCardCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionSendFromMeMessageCardCell at_identifier]];
            }
            [cell setCellDataWithModel:model];
            break;
        }
        case Notify: {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionSystemMessageTableViewCell at_identifier]];
            if (!cell) {
                cell = [[MissionSystemMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionSystemMessageTableViewCell at_identifier]];
            }
            [cell setCellDataWithModel:model];
            [[cell titelLb] setAttributedText:[self getAttributedStringWithString:model.msgInfo]];
            break;
        }
    }

    
    return cell;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + CGRectGetHeight(self.tableView.frame) >= self.tableView.contentSize.height - 100) {
        self.scrollToBottom = YES;
    } else {
        self.scrollToBottom = NO;
    }
}

#pragma mark -private method
- (void)configElements {
}
- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string
{
    if (string.length > 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        return attributedString;
    }
    else {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
}
- (CGFloat)getRowHeightWithString:(NSMutableAttributedString *)content
{
    // 得到输入文字内容长度
    static MissionSystemMessageTableViewCell *templateCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [self.tableView dequeueReusableCellWithIdentifier:[MissionSystemMessageTableViewCell at_identifier]];
        if (!templateCell) {
            templateCell = [[MissionSystemMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionSystemMessageTableViewCell at_identifier]];
        }
    });
    templateCell.titelLb.attributedText = content;
    
    CGFloat height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    return MAX(W_MINHEIGHT, height) > W_MINHEIGHT ? height + 9 : W_MINHEIGHT;
}

#pragma mark - event Response

#pragma mark - Delegate

#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - Interface
- (void)clickBlock:(MissionMessageListAdpterBlock)block
{
    self.block = block;
}
#pragma mark - init UI
@end

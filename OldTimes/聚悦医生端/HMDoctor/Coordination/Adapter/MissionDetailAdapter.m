//
//  MissionDetailAdapter.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionDetailAdapter.h"
#import "MissionDetailTitleTableViewCell.h"
#import "HMDoctorEnum.h"
#import "MissionDetailButtonCell.h"
#import "NewApplycommentbtnsView.h"
#import "NewApplyCommentTableViewCell.h"
#import "NSDate+String.h"
#import "MissionCommentsModel.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "NSString+TaskStringFormat.h"
#import "Slacker.h"
#import "MissionDetailTimeTanleViewCell.h"
#import "MissionRemarkAndPatientTableViewCell.h"
#import "MissionRemarkCell.h"
#import "DateUtil.h"
#import "MissionDetailModel.h"

#define W_MINHEIGHT 44   //最小高度
#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 60) // 文字最大宽度
#define OFFSET 10       // 偏移量

@interface MissionDetailAdapter ()
@property (nonatomic, strong) NewApplycommentbtnsView *btnview;
@property (nonatomic, strong) UIView *subview;

@end

@implementation MissionDetailAdapter

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == self.adapterArray.count - 1) {
        return self.arrayCommentsList.count;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.adapterArray.count - 1)
    {
        return 15 + 40;
    }
    else if (section == 2) {
        return self.model.hasAttachments ? 15 : 0.01;
    }
    else if (section == 3) {
        return self.model.remark.length > 0 ? 15 : 0.01;
    }
    else {
        return 15;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 0) {
//        return 15;
//    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];

    if (indexPath.section == self.adapterArray.count - 1) {
        // 评论
        NewApplyCommentTableViewCell *cell = [[NewApplyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NewApplyCommentTableViewCell identifier] CellKind:CellKind_Comment];
        if (self.arrayCommentsList.count > 0) {
            MissionCommentsModel *modelTemp = self.arrayCommentsList[indexPath.row];
            [cell configCommentModel:modelTemp];
        }
        return [cell getHeight];

    }
    else if (realIndex == MissionDetailCell_Type_Accessory) {
        // 附件
        if (!self.model.hasAttachments) {
            return 0;
        }
        return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:[[self.model.attachmentsPath hm_convertCuttingLineStringToArrayComponentsSeparatedByPeriodString] count] accessoryMode:NO];

    }
    else if (realIndex == MissionDetailCell_Type_Patient) {
    //患者
        return [self getRowHeightWithString:[self getAttributedStringWithString:[self.model.patientsName hm_formatCuttingLineStringSeparatedByPeriodString]]];
    }
    else if (realIndex == MissionDetailCell_Type_Detail) {
    //备注
        return self.model.remark.length > 0 ? 105 : 0;
    }
    else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    if (indexPath.section == self.adapterArray.count - 1) { //评论Cell
         cell = [tableView dequeueReusableCellWithIdentifier:[NewApplyCommentTableViewCell identifier]];
        if (!cell) {
            cell = [[NewApplyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NewApplyCommentTableViewCell identifier] CellKind:CellKind_Comment];
        }
        if (self.arrayCommentsList.count > 0) {
            MissionCommentsModel *modelTemp = self.arrayCommentsList[indexPath.row];
            [cell configCommentModel:modelTemp];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    switch (realIndex) {
        case MissionDetailCell_Type_Title:  //标题
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionDetailTitleTableViewCell at_identifier]];
            if (!cell) {
                cell = [[MissionDetailTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionDetailTitleTableViewCell at_identifier]];
            }
            [cell configTitleCellWithModel:self.model];
            
            break;
        }
            
        case MissionDetailCell_Type_StartTime:
        case MissionDetailCell_Type_EndTime:
        case MissionDetailCell_Type_Member:
        case MissionDetailCell_Type_Remind:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[UITableViewCell at_identifier]];
                [[cell textLabel] setFont:[UIFont font_30]];
                [[cell textLabel] setTextColor:[UIColor commonGrayTextColor]];
                [[cell detailTextLabel] setFont:[UIFont font_30]];
                [[cell detailTextLabel] setTextColor:[UIColor commonBlackTextColor_333333]];
                [[cell detailTextLabel] setNumberOfLines:0];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            NSString *title = self.adapterArray[indexPath.section][indexPath.row];
            NSString *detailTitle = @"";
            
            switch (realIndex) {
                case MissionDetailCell_Type_Member:
                {
                    detailTitle = [NSString stringWithFormat:@"%@ %@",self.model.pShowName,self.model.participatorName];
                    break;
                }
                case MissionDetailCell_Type_Remind:
                {
                    detailTitle = [MissionTypeEnum getTitelWithMissionTaskRemindType:self.model.remindType];
                    break;
                }
                    
                case MissionDetailCell_Type_StartTime:
                {
                    detailTitle = [self formateDateWithDateString:self.model.startTime wholeDay:self.model.isStartAllDay];
                    break;
                }
                case MissionDetailCell_Type_EndTime:
                {
                    detailTitle = [self formateDateWithDateString:self.model.endTime wholeDay:self.model.isEndAllDay];
                    break;
                }
            }
            
            [[cell textLabel] setText:title];
            [[cell detailTextLabel] setText:detailTitle];
            break;
        }
            
        case MissionDetailCell_Type_Patient:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionRemarkAndPatientTableViewCell identifier]];
            if (!cell) {
                cell = [[MissionRemarkAndPatientTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionRemarkAndPatientTableViewCell identifier]];
                [[cell titelLb] setFont:[UIFont font_30]];
                [[cell titelLb] setTextColor:[UIColor commonGrayTextColor]];
                [[cell contentLb] setFont:[UIFont font_30]];
                [[cell contentLb] setTextColor:[UIColor commonBlackTextColor_333333]];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            NSMutableAttributedString *attrText = [self getAttributedStringWithString:[self.model.patientsName hm_formatCuttingLineStringSeparatedByPeriodString]];

            [[cell titelLb] setText:self.adapterArray[indexPath.section][indexPath.row]];
            [[cell contentLb] setAttributedText:attrText];
            break;
        }

        case MissionDetailCell_Type_Accessory:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            if (!cell) {
                cell = [[ApplicationAttachmentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
                [[cell titleLabel] setTextColor:[UIColor commonGrayTextColor]];
            }
            [cell titleLabel].text = self.adapterArray[indexPath.section][indexPath.row];
            __weak typeof(self) weakSelf = self;
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([strongSelf.customDelegate respondsToSelector:@selector(missionDetailAdapterDelegateCallBack_accessoryClickImageIndex:)]) {
                    [strongSelf.customDelegate missionDetailAdapterDelegateCallBack_accessoryClickImageIndex:clickedIndex];
                }
            }];
            // 设置图片路径
            [cell configImagePath:[self.model.attachmentsPath hm_convertCuttingLineStringToArrayComponentsSeparatedByPeriodString]];
            [cell setHidden:!self.model.hasAttachments];
            break;
        }
            
        case MissionDetailCell_Type_Detail:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionRemarkCell at_identifier]];
            if (!cell) {
                cell = [[MissionRemarkCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionRemarkCell at_identifier]];
                [[cell textView] setTextColor:[UIColor commonGrayTextColor]];
                [cell textView].editable = NO;
                [cell hidePlaceholder:YES];
            }
            [[cell textView] setText:self.model.remark ? : @""];
            [cell setHidden:!(self.model.remark.length > 0)];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        if (section == self.adapterArray.count - 1)
        {
           return self.subview;
        }
        else
        {
            return nil;
        }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.adapterArray.count - 1) { //评论Cell
        return nil;
    }
    return indexPath;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.baseVC.view endEditing:YES];
}

- (NSUInteger)realIndexAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}

#pragma mark - private method
- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:9];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    if ([self getRowHeightWithString:attributedString] == W_MINHEIGHT) {
        paragraphStyle.alignment = NSTextAlignmentRight;
    } else {
        paragraphStyle.alignment = NSTextAlignmentLeft;
    }

    return attributedString;
}
- (void)configElements {
}

- (void)postCommentTypeClickedDelegateWithType:(TaskCommentType)type {
    if ([self.customDelegate respondsToSelector:@selector(missionDetailAdapterDelegateCallBack_commentTypeClicked:)]) {
        [self.customDelegate missionDetailAdapterDelegateCallBack_commentTypeClicked:type];
    }
}

- (void)postWriteCommentClickedDelegate {
    if ([self.customDelegate respondsToSelector:@selector(missionDetailAdapterDelegateCallBack_writeCommentClicked)]) {
        [self.customDelegate missionDetailAdapterDelegateCallBack_writeCommentClicked];
    }
}

- (CGFloat)getRowHeightWithString:(NSMutableAttributedString *)content
{
    // 得到输入文字内容长度
    static MissionRemarkAndPatientTableViewCell *templateCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [self.tableView dequeueReusableCellWithIdentifier:[MissionRemarkAndPatientTableViewCell identifier]];
        if (!templateCell) {
            templateCell = [[MissionRemarkAndPatientTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionRemarkAndPatientTableViewCell identifier]];
        }
    });
    templateCell.contentLb.attributedText = content;
    
    CGFloat height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    return MAX(W_MINHEIGHT, height) > W_MINHEIGHT ? height + 9 : W_MINHEIGHT;
}

- (NSString *)formateDateWithDateString:(NSString *)dateString wholeDay:(BOOL)wholeDay {
    NSString *formattedString = @"yyyy-MM-dd HH:mm:ss";
    NSString *formattedDate;
    NSDate *date = [DateUtil convertDateFromString:dateString formatString:formattedString];
    formattedDate  = [DateUtil stringDateWithDate:date dateFormat:wholeDay ? @"yyyy年MM月dd日" : @"yyyy年MM月dd日 HH:mm:ss"];
    return formattedDate ? :@"";
}

#pragma mark - event Response

#pragma mark - NewMissionDetailTitelTableViewCellDelegate


#pragma mark - UITableViewDelegate

#pragma mark - request Delegate

#pragma mark - updateViewConstraints

#pragma mark - init UI

- (NewApplycommentbtnsView *)btnview
{
    if (!_btnview)
    {
        _btnview = [[NewApplycommentbtnsView alloc] initWithFrame:CGRectMake(0, 15, self.baseVC.view.frame.size.width, 40)];
        __weak typeof(self) weakSelf = self;
        [_btnview setblock:^(TaskCommentType type) {
            [weakSelf postCommentTypeClickedDelegateWithType:type];
        }];
        [_btnview addNotiWriteCommentButtonClicked:^{
            // 写评论按钮点击
            [weakSelf postWriteCommentClickedDelegate];
        }];
    }
    return _btnview;
}
- (UIView *)subview
{
    if (!_subview)
    {
        _subview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.baseVC.view.frame.size.width, 55)];
        [_subview addSubview:self.btnview];
    }
    return _subview;
}
@end

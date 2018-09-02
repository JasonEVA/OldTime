//
//  MissionAddNewMissionAdapter.m
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "MissionAddNewMissionAdapter.h"
#import "HMDoctorEnum.h"
#import "NewTaskWithSegmentTableViewCell.h"
#import "MissionCCTeamLeaderCell.h"
#import "MissionTitelTableViewCell.h"
#import "MissionTitelPopupCell.h"
#import "MissionDatePickerCell.h"
#import "ApplicationAttachmentTableViewCell.h"
#import "NSDate+String.h"
#import "MissionRemarkCell.h"
#import "MissionDetailModel.h"
#import "NSString+TaskStringFormat.h"
#import "MissionAddMissionPatientTableView.h"

#define W_MINHEIGHT 44   //最小高度
#define W_MAX   ([ [ UIScreen mainScreen ] bounds ].size.width - 130) // 文字最大宽度
#define OFFSET 10       // 偏移量
@interface MissionAddNewMissionAdapter ()<MissionDatePickerCellDelegate,UITextViewDelegate,UITextFieldDelegate>

@end

@implementation MissionAddNewMissionAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 15;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    
    if (realIndex == CellType_StartTimePicker) { //时间选择弹出cell高度
        return self.startTimeCellIsopen ? 260 : 0;
    }
    else if (realIndex == CellType_DeadlineTimePicker) {
        return self.endTimeCellIsopen ? 260 : 0;
    }
    switch (realIndex) {
        case CellType_Accessory:
        {
            return [ApplicationAttachmentTableViewCell heightForCellWithImageCount:self.uploadOriImages.count accessoryMode:YES];
            break;
        }
        case CellType_Patient:
        {
            return [self getRowHeightWithString:[self getAttributedStringWithString:[[self getComponentFromDictionaryOrModel:CellType_Patient] hm_formatCuttingLineStringSeparatedByPeriodString]]];
            break;
        }
        case CellType_Details: {
            return 105;
        }
        
        default:
            return 44;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    NSUInteger realIndex = [self realIndexAtIndexPath:indexPath];
    switch (realIndex) {
        case CellType_Title: //标题
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionTitelTableViewCell identifier]];
            if (!cell) {
                cell = [[MissionTitelTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionTitelTableViewCell identifier]];
                [cell textField].delegate = self;
            }
            [cell textField].tag = CellType_Title;
            NSString *titel = @"任务标题";
            //[[cell textField] setEnabled:NO];
            if ([[self getComponentFromDictionaryOrModel:CellType_Title] length] == 0) {
                //[[cell textField] setEnabled:YES];
                [[cell textField] setPlaceholder:@"输入自定义类型"];
            }
            [[cell textField] setText:[self getComponentFromDictionaryOrModel:CellType_Title]];
            __weak typeof(self) weakSelf = self;
            [cell btnSelect:^{ //选择按钮点击
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.baseVC.view endEditing:YES];
                [strongSelf insertTableViewRowes];
                if ([strongSelf isPopupState]) {
                   // [[cell textField] setEnabled:NO];
                }
                if ([[strongSelf getComponentFromDictionaryOrModel:CellType_Title] length] == 0) {
                   // [[cell textField] setEnabled:YES];
                    [[cell textField] setPlaceholder:@"输入自定义类型"];
                }

            }];
            [cell lblTitle].text = titel;
            break;
        }
            
        case CellType_Urgent: //加急
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionCCTeamLeaderCell identifier]];
            if (!cell) {
                cell = [[MissionCCTeamLeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionCCTeamLeaderCell identifier]];
            }
            [cell lblTitle].text = @"加急";
            [[cell lblTitle] setTextColor:[UIColor commonDarkGrayColor_666666]];
            [cell configSwitchState:(self.detailModel.taskPriority == MissionTaskPriorityHigh)];
            __weak typeof(self) weakSelf = self;
            [cell switchDidSelect:^(BOOL state) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.detailModel.taskPriority = state ? MissionTaskPriorityHigh : MissionTaskPriorityNone;
            }];
            break;

        }
          
        case CellType_Patient:    // 患者
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionAddMissionPatientTableView identifier]];
            if (!cell) {
                cell = [[MissionAddMissionPatientTableView alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionAddMissionPatientTableView identifier]];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell contentLb].attributedText = [self getAttributedStringWithString:[[self getComponentFromDictionaryOrModel:CellType_Patient] hm_formatCuttingLineStringSeparatedByPeriodString]];
            NSArray *tempArr = [self.detailModel.patientsID hm_convertCuttingLineStringToArrayComponentsSeparatedByPeriodString];
            if (tempArr.count)
            {
                [[cell titelLb] setText:[NSString stringWithFormat:@"用户(%lu)",(unsigned long)[tempArr count]]];
            }
            else {
                [[cell titelLb] setText:@"用户"];
            }
            break;
        }
        case CellType_StartTimePicker:
        case CellType_DeadlineTimePicker:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionDatePickerCell identifier]];
            if (!cell) {
                cell = [[MissionDatePickerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionDatePickerCell identifier]];
            }
            
            if (realIndex == CellType_StartTimePicker){
                NSDate *tempDate = [self translateTimeStrToDate:self.detailModel.startTime];
                [cell setDate:tempDate];
                ((MissionDatePickerCell *)cell).hidden = !self.startTimeCellIsopen;
            }
            else
            {
                NSDate *tempDate = [self translateTimeStrToDate:self.detailModel.endTime];
                [cell setDate:tempDate];
                ((MissionDatePickerCell *)cell).hidden = !self.endTimeCellIsopen;
            }
            [cell setIndexPath:indexPath];
            [cell wholeDayIsOn:indexPath.row == 1?self.detailModel.isStartAllDay:self.detailModel.isEndAllDay];
            [cell setDelegate:self];
            break;
        }

        case CellType_Member:    // 参与者
        case CellType_StartTime: // 开始时间
        case CellType_Deadline: // 结束时间
        case CellType_Alert: // 提醒时间
//        case CellType_AddToCalendar: // 加入日程
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell at_identifier]];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[UITableViewCell at_identifier]];
                [[cell textLabel] setFont:[UIFont systemFontOfSize:15]];
                [[cell textLabel] setTextColor:[UIColor commonDarkGrayColor_666666]];
                [[cell detailTextLabel] setTextAlignment:NSTextAlignmentRight];
                [[cell detailTextLabel] setTextColor:[UIColor blackColor]];
                [[cell detailTextLabel] setFont:[UIFont systemFontOfSize:15]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            NSString *detailTitel = @"";
            [[cell textLabel] setText:self.adapterArray[indexPath.section][indexPath.row]];
            switch (realIndex) {
                case CellType_Member: // 参与者
                {
                    detailTitel = [self getComponentFromDictionaryOrModel:CellType_Member];
                    break;
                }
                case CellType_StartTime: //开始时间
                {
                    detailTitel = self.detailModel.startTime;
                    break;
                }
                case CellType_Deadline:  //结束时间
                {
                    detailTitel = self.detailModel.endTime;
                    break;
                }
                case CellType_Alert:       //提醒
                {
                    detailTitel = [MissionTypeEnum getTitelWithMissionTaskRemindType:[[self getComponentFromDictionaryOrModel:CellType_Alert] integerValue]];
                    break;
                }
//                case CellType_AddToCalendar:       // 添加到我的日程
//                {
//                    break;
//                }
                    
            }
            
            [[cell detailTextLabel] setText:detailTitel];
            break;
        }
           
            
        case CellType_GroupTask:   // 项目组任务
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionCCTeamLeaderCell identifier]];
            if (!cell) {
                cell = [[MissionCCTeamLeaderCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionCCTeamLeaderCell identifier]];
            }
            [cell lblTitle].text = @"项目组任务";
            [[cell lblTitle] setTextColor:[UIColor commonDarkGrayColor_666666]];
            [cell configSwitchState:self.detailModel.isMemberAccess];
            __weak typeof(self) weakSelf = self;
            [cell switchDidSelect:^(BOOL state) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.detailModel.isMemberAccess = state;
            }];
            break;
        }

        case CellType_Accessory: //附件
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[ApplicationAttachmentTableViewCell identifier]];
            if (!cell) {
                cell = [[ApplicationAttachmentTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[ApplicationAttachmentTableViewCell identifier]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            [cell titleLabel].text = @"附件";
            [[cell titleLabel] setTextColor:[UIColor commonDarkGrayColor_666666]];
            __weak typeof(self) weakSelf = self;
            [cell clickToSeeImage:^(NSUInteger clickedIndex) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if ([strongSelf.delegate respondsToSelector:@selector(MissionAddNewMissionAdapterDelegateCallBack_accessoryClickImageIndex:)]) {
                    [strongSelf.delegate MissionAddNewMissionAdapterDelegateCallBack_accessoryClickImageIndex:clickedIndex];
                }
            }];
            // 设置图片路径
            [cell configOriImages:self.uploadOriImages];
            break;
        }

        case CellType_Details://备注
        {
            cell = [tableView dequeueReusableCellWithIdentifier:[MissionRemarkCell at_identifier]];
            if (!cell) {
                cell = [[MissionRemarkCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionRemarkCell at_identifier]];
                [cell textView].delegate = self;
            }
            [cell textView].tag = CellType_Details;
            NSString *titel = [self getComponentFromDictionaryOrModel:CellType_Details];
            [[cell textView] setText:titel.length > 0 ? titel : @""];
            break;
        }
            
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.baseVC.view endEditing:YES];
}

#pragma mark - TextView Delegage

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(MissionAddNewMissionAdapterDelegateCallBack_textFieldEndEditWithText:cellType:)]) {
        [self.delegate MissionAddNewMissionAdapterDelegateCallBack_textFieldEndEditWithText:textView.text cellType:(Cell_Type)textView.tag];
    }
}

#pragma mark - TextField Delegage

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(MissionAddNewMissionAdapterDelegateCallBack_textFieldEndEditWithText:cellType:)]) {
        [self.delegate MissionAddNewMissionAdapterDelegateCallBack_textFieldEndEditWithText:textField.text cellType:(Cell_Type)textField.tag];
    }
}

#pragma mark - private mothed
- (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string
{
    if (string.length > 0) {
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
    else {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
}
- (CGFloat)getRowHeightWithString:(NSMutableAttributedString *)content
{
    // 得到输入文字内容长度
    static MissionAddMissionPatientTableView *templateCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        templateCell = [self.tableView dequeueReusableCellWithIdentifier:[MissionAddMissionPatientTableView identifier]];
        if (!templateCell) {
            templateCell = [[MissionAddMissionPatientTableView alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[MissionAddMissionPatientTableView identifier]];
        }
    });
    templateCell.contentLb.attributedText = content;
    CGFloat height = [templateCell.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height;
    return MAX(W_MINHEIGHT, height) > W_MINHEIGHT ? height + 9 : W_MINHEIGHT;
}
- (NSDate *)translateTimeStrToDate:(NSString *)timeStr
{
    NSArray *tempArray = [timeStr componentsSeparatedByString:@" "];
    
    NSInteger year = [[timeStr substringToIndex:4] integerValue];
    NSInteger month = [[timeStr substringWithRange:NSMakeRange(5, 2)] integerValue];
    NSInteger day = [[timeStr substringWithRange:NSMakeRange(8, 2)]  integerValue];
    
    if (tempArray.count == 2 ) { //非全天的
        NSInteger hour = [[timeStr substringWithRange:NSMakeRange(11, 2)] integerValue];
        NSInteger minute = [[timeStr substringWithRange:NSMakeRange(14, 2)] integerValue];
        NSInteger second = [[timeStr substringWithRange:NSMakeRange(17, 2)] integerValue];
        return  [NSDate dateWithYear:year month:month day:day hour:hour minute:minute second:second];
    }
    else                         //全天的
    {
       return [NSDate dateWithYear:year month:month day:day];
    }
    return [NSDate date];
}

/** 优先度Cell点击 */
- (void)selectImportanceAtIndex:(NSUInteger)selectedIndex {
    self.detailModel.taskPriority = selectedIndex;
}

- (NSUInteger)realIndexAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section * 10 + indexPath.row;
}
- (BOOL)isPopupState
{
    NSArray *firstArr = self.adapterArray.firstObject;
    if (firstArr.count > 1) {
        return YES;
    } else {
        return NO;
    }
}

- (void)insertTableViewRowes
{
    if ([self.delegate respondsToSelector:@selector(MissionAddNewMissionAdapterDelegateCallBack_insterRow)]) {
        [self.delegate MissionAddNewMissionAdapterDelegateCallBack_insterRow];
    }
}

- (id)getComponentFromDictionaryOrModel:(Cell_Type)requestStyle {
    if (self.detailModel) {
        switch (requestStyle) {
                
            case CellType_Title:
                return self.detailModel.taskTitle;
                
            case CellType_Member:
                return self.detailModel.participatorName;

            case CellType_Patient:
                return self.detailModel.patientsName;
                
            case CellType_StartTime:
                return self.detailModel.startTime;

            case CellType_Deadline:
                return self.detailModel.endTime;
                
            case CellType_Details:
                return self.detailModel.remark;

            case CellType_GroupTask:
                // TODO:
                return @(self.detailModel.isMemberAccess);

            case CellType_Alert:
                return @(self.detailModel.remindType);
                
            case CellType_Urgent:
                return @(self.detailModel.taskPriority);
            
            case CellType_Accessory: {
                if (self.detailModel.attachmentsPath.length > 0) {
                    NSArray *arr = [self.detailModel.attachmentsPath componentsSeparatedByString:@"|"];
                    return arr;
                }
                return nil;
            }
                
            default:;
                return nil;
        }

    }
    
        return nil;
}

#pragma mark - MissionDatePickerCellDelegate

//确定或取消或无
- (void)MissionDatePickerCellCallBack_didSelectAtIndexPath:(NSIndexPath *)indexPath date:(NSDate *)date isWholeDay:(BOOL)isWholdDay isNone:(BOOL)isNone
{
    if ([self.delegate respondsToSelector:@selector(MissionAddNewMissionAdapterDelegateCallBack_startTimeSelectHideAtIndexPath:date:isWholeDay:isNone:)]) {
        [self.delegate MissionAddNewMissionAdapterDelegateCallBack_startTimeSelectHideAtIndexPath:indexPath date:date isWholeDay:isWholdDay isNone:isNone];
    }
}

#pragma mark - init

- (MissionDetailModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [MissionDetailModel new];
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd"];
        _detailModel.startTime = [dateformat stringFromDate:[NSDate date]];
        _detailModel.endTime = [dateformat stringFromDate:[NSDate date]];
        _detailModel.isStartAllDay = 1;
        _detailModel.isEndAllDay = 1;
    }
    return _detailModel;
}

@end

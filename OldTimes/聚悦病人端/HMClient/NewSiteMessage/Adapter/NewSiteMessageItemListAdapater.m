//
//  NewSiteMessageItemListAdapater.m
//  HMClient
//
//  Created by jasonwang on 2016/10/31.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "NewSiteMessageItemListAdapater.h"
#import "EncodeAudio.h"

@interface NewSiteMessageItemListAdapater ()
@property (nonatomic) BOOL isVoiceDownLoading;     //语音是否正在下载
@property (nonatomic, copy) AlterClickImage block;
@end

@implementation NewSiteMessageItemListAdapater
- (UITableViewCell *)tableView:(UITableView *)tableView cellForSiteMessageLastMsgModel:(SiteMessageLastMsgModel *)model {
    id cell;
    SiteMessageSecondEditionType siteMessageType = [NewSiteMessageMessageTypeENUM acquireMessageTypeWithString:model.typeCode];
    
    switch (siteMessageType) {
        case SiteMessageSecondEditionType_YSGH:
        {//医生关怀 YSGH
            NewSiteMessageYSGHType YSGHType = [NewSiteMessageMessageTypeENUM acquireNewSiteMessageYSGHTypeWithString:model.msgContent.mj_JSONObject[@"type"]];
            switch (YSGHType) {
                case NewSiteMessageYSGHType_userCarePage:
                {//医生问候 userCarePage
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageDoctorCareTableViewCell at_identifier]];
                    [cell fillDataWithModel:model];
                    __weak typeof(self) weakSelf = self;
                    [cell imageClick:^(NSArray *imagesArr, NSIndexPath *concernIndexPath) {
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        if (strongSelf.block) {
                            strongSelf.block(imagesArr, concernIndexPath.row);
                        }
                    }];
                    
                    [cell playVoiceClickBlock:^{
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        //语音播放
                        NewSiteMessageDoctorConcernModel *tempModel  = [NewSiteMessageDoctorConcernModel mj_objectWithKeyValues:model.msgContent.mj_JSONObject];
                        NSString* string = tempModel.voice;
                        
                        if (tempModel)
                        {
                            if (!strongSelf.lastCell) {   //第一次点击
                            }
                            else if (strongSelf.lastCell == cell) {  //点击同一个
                                if (strongSelf.isVoiceDownLoading) {
                                    return;
                                }
                                
                                if ([strongSelf.player isPlaying]) {
                                    [strongSelf.player stopPlay];
                                    [[strongSelf.lastCell voiceImages] stopAnimating];
                                    return;
                                }
                            }
                            else {  //点击其他cell的语音播放
                                strongSelf.isVoiceDownLoading = NO;
                                [[strongSelf.lastCell voiceImages] stopAnimating];
                            }
                            
                            strongSelf.lastCell = cell;
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                
                                strongSelf.isVoiceDownLoading = YES;
                                NSData* wavdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:tempModel.voice]];
                                //amr转wav播放
                                NSData* armToWavData = [EncodeAudio convertAmrToWavFile:wavdata];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if (!wavdata)
                                    {
                                        return;
                                    }
                                    if ([string containsString:@".wav"])
                                    {
                                        [[cell voiceImages] startAnimating];
                                        [strongSelf.player playAudioData:wavdata callBack:^{
                                            [[cell voiceImages] stopAnimating];
                                            
                                        }];
                                    } else
                                    {
                                        [[cell voiceImages] startAnimating];
                                        
                                        [strongSelf.player playAudioData:armToWavData callBack:^{
                                            [[cell voiceImages] stopAnimating];
                                            
                                        }];
                                    }
                                    strongSelf.isVoiceDownLoading = NO;
                                    
                                });
                            });
                        }
                        
                    }];

                    return cell;
                }
                case NewSiteMessageYSGHType_roundsAsk:
                {//查房 roundsAsk
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageRoundsTableViewCell at_identifier]];
                    [cell fillDataWithModel:model];
                    return cell;
                }
                case NewSiteMessageYSGHType_surveyPush:
                {//随访 surveyPush
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageVisitTableViewCell at_identifier]];
                    [cell fillDataWithModel:model];
                    
                    return cell;
                }
                case NewSiteMessageYSGHType_serviceComments:
                {//服务评价 serviceComments
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageLeftImageTableViewCell at_identifier]];
                    [cell fillDataWithModel:model];
                    
                    return cell;
                }
                case NewSiteMessageYSGHType_surveyReply:{
                    // 随访医生回复
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteSystemTableViewCell at_identifier]];
                    [cell fillDataWithModel:model];
                    return cell;
                    break;
                }
                default:
                    break;
            }

            break;
        }
        case SiteMessageSecondEditionType_JKNZ:
        {//健康闹钟   JKNZ
            NewSiteMessageJKNZType JKNZType = [NewSiteMessageMessageTypeENUM acquireNewSiteMessageJKNZTypeWithString:model.msgContent.mj_JSONObject[@"type"]];
            
            switch (JKNZType) {
                case NewSiteMessageJKNZType_reviewPush:
                {//复查提醒 reviewPush
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageTemindReviewTableViewCell at_identifier]];
                    [cell fillDataWithModel:model];
                    return cell;
                }
                case NewSiteMessageJKNZType_drugPush:
                {//用药提醒 drugPush
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageMedicationRemindTableViewCell at_identifier]];
                    [cell fillDataWithModel:model];
                    
                    return cell;
                }
                case NewSiteMessageJKNZType_healthTest:
                {//监测提醒 healthTest
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageMonitorRemindedTableViewCell at_identifier]];
                    [cell fillDataWithModel:model];
                    return cell;
                }
                default:
                    break;
            }
            
            break;
        }
        case SiteMessageSecondEditionType_WDYZ:
        {//我的约诊 WDYZ
            NewSiteMessageWDYZType WDYZType = [NewSiteMessageMessageTypeENUM acquireNewSiteMessageWDYZTypeWithString:model.msgContent.mj_JSONObject[@"type"]];
            switch (WDYZType) {
                case NewSiteMessageWDYZType_appointAgree:
                case NewSiteMessageWDYZType_appointRefuse:
                case NewSiteMessageWDYZType_appointCancel:
                case NewSiteMessageWDYZType_appointChange:
                case NewSiteMessageWDYZType_appointremind:
                {
            
                    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageAppointmentRemindTableViewCell at_identifier]];
                    [cell fillAppointWithModel:model];
                    
                    return cell;
                }
                    
                default:
                    break;
            }
            break;
        }
        case SiteMessageSecondEditionType_JKJH:
        {//健康计划 JKJH
            cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageAppointmentRemindTableViewCell at_identifier]];
            [cell fillHealthPlanDataWithModel:model];

            return cell;
        }
        case SiteMessageSecondEditionType_JKPG:
        {//健康评估 JKPG
            cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageAppointmentRemindTableViewCell at_identifier]];
            [cell fillAssessWithModel:model];
            
            return cell;
        }
        case SiteMessageSecondEditionType_JKBG:
        {//健康报告 JKBG
            cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageAppointmentRemindTableViewCell at_identifier]];
            [cell fillHealReportWithModel:model];
            
            return cell;
        }
        case SiteMessageSecondEditionType_XTXX:
        {//系统消息 XTXX
            cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageSystemTableViewCell at_identifier]];
            [cell fillDataWithModel:model];
            
            return cell;
        }
        case SiteMessageSecondEditionType_JKKT:
        {//健康课堂 JKKT
            cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageHealthClassTableViewCell at_identifier]];
            [cell fillDataWithModel:model];
            
            return cell;
        }
        default:
        {
            break;
        }
    }
    
    //防止脏数据，默认以文本显示
    cell = [tableView dequeueReusableCellWithIdentifier:[NewSiteMessageTextTableViewCell at_identifier]];
    [cell fillDataWithModel:model];
    return cell;
}

- (void)collectImageClick:(AlterClickImage)block {
    self.block = block;
}

- (AudioPlayHelper *)player {
    if (!_player) {
        _player = [AudioPlayHelper new];
    }
    return _player;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000000001;
}

@end

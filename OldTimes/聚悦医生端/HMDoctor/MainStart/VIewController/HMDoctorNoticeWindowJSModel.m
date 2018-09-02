//
//  HMDoctorNoticeWindowJSModel.m
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMDoctorNoticeWindowJSModel.h"

@implementation HMDoctorNoticeWindowJSModel

- (void)sendYHNotesId:(NSString *)notesId {
    if (self.delegate) {
        [self.delegate HMDoctorNoticeWindowJSModelDelegateCallBack_SendClick:SendType_Patitent noteId:notesId];
    }
}

- (void)sendWorkNotesId:(NSString *)notesId {
    if (self.delegate) {
        [self.delegate HMDoctorNoticeWindowJSModelDelegateCallBack_SendClick:SendType_Work noteId:notesId];
    }

}

- (void)backPre {
    if (self.delegate) {
        [self.delegate HMDoctorNoticeWindowJSModelDelegateCallBack_SendClick:Back noteId:nil];
    }
}
@end

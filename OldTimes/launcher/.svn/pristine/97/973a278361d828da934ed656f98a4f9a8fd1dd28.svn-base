//
//  MeetingNameListLabelsView.h
//  launcher
//
//  Created by 马晓波 on 15/8/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetingNameListBtn.h"

@protocol MeetingNameListLabelsViewDelegate <NSObject>
- (void)MeetingNameListLabelsViewCallback_delegateWithbtn:(MeetingNameListBtn *)btn;
@end

@interface MeetingNameListLabelsView : UIView
@property (nonatomic, weak) id<MeetingNameListLabelsViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *arrBtns;
-(instancetype)initWithFrame:(CGRect)frame ArrNameLsit:(NSArray *)arrNameList;
@end

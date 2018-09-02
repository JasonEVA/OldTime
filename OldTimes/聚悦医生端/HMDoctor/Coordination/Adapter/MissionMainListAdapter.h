//
//  MissionMainListAdapter.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ATTableViewAdapter.h"
#import "MissionMainListHeadView.h"

typedef void(^showAlterViewCallBackBlock)(BOOL isFinished, UITableViewCell *cell);
@protocol MissionMainListAdapterDelegate <NSObject>

- (void)missionMainListAdapterDelegateCallBack_newDraftWithCellData:(id)CellData;

@end

@interface MissionMainListAdapter : ATTableViewAdapter

@property (nonatomic, strong) NSMutableArray *headViewTitelArr;
@property (nonatomic) MissionType selectType;
@property (nonatomic, strong)  NSMutableArray  *arrayButtons; // <##>
@property (nonatomic, weak)  id<MissionMainListAdapterDelegate>  customDelegate; // <##>

- (void)showAlterViewWithBlock:(showAlterViewCallBackBlock)block;
@end

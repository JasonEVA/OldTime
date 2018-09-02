//
//  NewMissionMainViewController.h
//  launcher
//
//  Created by TabLiu on 16/2/14.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "AppBaseViewController.h"

typedef  void (^changeLiftVCSelectCell)(NSIndexPath * path,NSString * showId);

typedef enum{
    VCkind_Today = 0,
    VCkind_Tomorrow = 1,
    VCkind_All = 2,
    VCkind_Notime = 3,
    VCkind_Send = 4,
    VCkind_Done = 5,
    VCkind_nil = 100
}VCkind;

@class ProjectContentModel;
@interface NewMissionMainViewController : AppBaseViewController

- (void)liftTableViewVC_ChangeSelectCellWithPath:(NSIndexPath *)indexPath model:(ProjectContentModel *)model;

- (void)drawerStart:(BOOL)isShow;

- (void)changeLeftVCSelectCellWithBlock:(changeLiftVCSelectCell)block;

 
@end

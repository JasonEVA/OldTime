//
//  HMFEPatientListSearchResultViewController.h
//  HMDoctor
//
//  Created by jasonwang on 2017/10/19.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第四版病人搜索界面

#import <UIKit/UIKit.h>

typedef void(^SearchResultClicked)(id resultData);

@interface HMFEPatientListSearchResultViewController : UITableViewController

//- (void)configWithSourceData:(NSArray *)arrayData;

- (void)updateResultsWithKeywords:(NSString *)keywords resultClicked:(SearchResultClicked)clicked;

- (instancetype)initWithSelectPatientVC;    //选人模式初始化方法

@property (nonatomic, strong) NSMutableArray *selectedPatientArr;
@property (nonatomic) NSInteger maxSelectedNum;                  //至多选择人数

@end


//
//  PatientSearchResultTableViewController.h
//  HMDoctor
//
//  Created by Andrew Shen on 2016/10/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  病人搜索界面

#import <UIKit/UIKit.h>

typedef void(^SearchResultClicked)(id resultData);

@interface PatientSearchResultTableViewController : UITableViewController

- (void)configWithSourceData:(NSArray *)arrayData;

- (void)updateResultsWithKeywords:(NSString *)keywords resultClicked:(SearchResultClicked)clicked;

- (instancetype)initWithSelectPatientVC;    //选人模式初始化方法

@property (nonatomic, strong) NSMutableArray *selectedPatientArr;
@property (nonatomic) NSInteger maxSelectedNum;                  //至多选择人数

@end

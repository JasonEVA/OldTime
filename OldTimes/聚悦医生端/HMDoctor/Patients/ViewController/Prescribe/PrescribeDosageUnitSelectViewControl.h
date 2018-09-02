//
//  PrescribeDosageUnitSelectViewControl.h
//  HMDoctor
//
//  Created by lkl on 16/6/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DosageUnitSelectBlock)(NSString* drugUsage);

@interface PrescribeDosageUnitSelectViewControl : UIViewController

+ (PrescribeDosageUnitSelectViewControl*) createWithParentViewController:(UIViewController*) parentviewcontroller
                                                                    drugId:(NSString *)drugId
                                                                      cellLocationY:(float)locationY
                                                                      cellLocationX:(float)locationX
                                                                selectblock:(DosageUnitSelectBlock)block;
@property (nonatomic, copy) DosageUnitSelectBlock selectblock;

@property (nonatomic, copy) NSString *drugId;
@property (nonatomic, strong) NSArray* dosageUnitItem;
@property (nonatomic, assign) float tableViewLocationX;
@property (nonatomic, assign) float tableViewLocationY;

@end
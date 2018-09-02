//
//  UpdateResultSymptomView.h
//  HMClient
//
//  Created by lkl on 16/5/19.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UpdateResultSymptomView : UIView

@property(nonatomic, readonly) UILabel *lbSymptom;

- (void)setSymptom:(NSString *)symptom;

- (void)setImage:(NSArray *)picUrls;

@end

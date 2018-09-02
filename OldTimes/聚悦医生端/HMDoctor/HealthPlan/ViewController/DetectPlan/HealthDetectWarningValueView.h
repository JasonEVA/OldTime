//
//  HealthDetectWarningValueView.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDetectWarningValueModel : NSObject

@property (nonatomic, retain) NSString* oneKpiCode;
@property (nonatomic, retain) NSString* oneKpiName;

@property (nonatomic, retain) NSString* oneBeginSymbol;
@property (nonatomic, retain) NSString* oneBeginValue;

@property (nonatomic, retain) NSString* oneEndSymbol;
@property (nonatomic, retain) NSString* oneEndValue;

@end


@interface HealthDetectWarningValueView : UIView
{
    UIControl* _kipControl;
}
@property (nonatomic, strong) UITextField* oneBeginValueTextField;
@property (nonatomic, strong) UILabel* oneBeginSymbolLabel;
@property (nonatomic, strong) UIControl* kipControl;
@property (nonatomic, strong) UITextField* oneEndValueTextField;
@property (nonatomic, strong) UILabel* oneEndSymbolLabel;

- (void) setHealthDetectWarningValueModel:(HealthDetectWarningValueModel*) model;

- (void) setSubKpiModel:(HealthDetectWarningSubKpiModel*) model;

@end

@interface HealthDetectWarningHighValueView : HealthDetectWarningValueView

@end

@interface HealthDetectWarningLowValueView : HealthDetectWarningValueView

@end

@interface HealthDetectBloodPressureWarningValueView : HealthDetectWarningValueView

@end

@interface HealthDetectBloodPressureWarningHighValueView : HealthDetectWarningHighValueView

@end

@interface HealthDetectBloodPressureWarningLowValueView : HealthDetectWarningLowValueView

@end

@interface HealthDetectWarningRelationControl : UIControl

- (void) setRelationString:(NSString*) relationString;
@end

@interface HealthDetectWarningRelationView: UIView

@property (nonatomic, strong) HealthDetectWarningRelationControl* relationControl;
@property (nonatomic, copy) NSString* relation;

@end

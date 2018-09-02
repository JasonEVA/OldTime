//
//  BloodFatResultValueView.h
//  HMClient
//
//  Created by yinqaun on 16/5/10.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodFatResultValueView : UIView

- (id)initWithName:(NSString*) name ExtName:(NSString*) extName;
- (void) setResultValue:(float) value;
@end

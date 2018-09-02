//
//  DetectRecordSegmentedView.h
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DetectRecordSegmentedDelegate;

@interface DetectRecordSegmentedView : UIView
{
    
}

@property (nonatomic, weak) id<DetectRecordSegmentedDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
@end

@protocol DetectRecordSegmentedDelegate <NSObject>

- (void) segmentedview:(DetectRecordSegmentedView*) segmentedview SelectedIndex:(NSInteger) selectedIndex;

@end

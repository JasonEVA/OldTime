//
//  ToolLibraryStartCollectionViewCell.h
//  HMDoctor
//
//  Created by lkl on 16/6/15.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolLibraryStartGirdInfo : NSObject
{
    
}
@property (nonatomic, retain) NSString* girdName;
@property (nonatomic, retain) NSString* girdImage;

@end

@interface ToolLibraryStartCollectionViewCell : UICollectionViewCell

- (void) setGirdImage:(NSString*) icon
             GirdName:(NSString*) name;

- (void) setNoOpenImage;

@end

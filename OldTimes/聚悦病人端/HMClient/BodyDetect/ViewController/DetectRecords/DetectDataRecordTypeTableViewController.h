//
//  DetectDataRecordTypeTableViewController.h
//  HMClient
//
//  Created by yinqaun on 16/5/11.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetectDataRecordType : NSObject
{
    
}

@property (nonatomic, retain) NSString* typeName;
@property (nonatomic, assign) NSString* kpiCode;

@end

typedef void(^DataRecordTypeSelectedBlock)(DetectDataRecordType* type);

@interface DetectDataRecordTypeSelectedViewController : UIViewController
{
    
}

+ (void) createSelectedControllerInParent:(UIViewController*) parentController
              DataRecordTypeSelectedBlock:(DataRecordTypeSelectedBlock) block;
@end

@interface DetectDataRecordTypeTableViewController : UITableViewController
{
    
}
@property (nonatomic, copy) DataRecordTypeSelectedBlock selectedBlock;
- (id) initWithTypeList:(NSArray*) list;
@end

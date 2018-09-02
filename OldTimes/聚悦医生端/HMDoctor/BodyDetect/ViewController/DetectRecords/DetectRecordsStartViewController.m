//
//  DetectRecordsStartViewController.m
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecordsStartViewController.h"
#import "DetectRecordSegmentedView.h"

//#import "DetectRecordsOverallTableViewController.h"
//#import "DetectRecordsContrastTableViewController.h"
#import "DetectRecordsSEContrastTableViewController.h"
#import "DetectRecordsSEOverallTableViewController.h"
#import "DetectDataRecordsTableViewController.h"

#import "DetectRecordOverallTimeView.h"
#import "DetectRecordDataSelectedControl.h"
#import "DetectDataRecordTypeTableViewController.h"

@interface DetectRecordsStartViewController ()
<DetectRecordSegmentedDelegate,
DetectRecordTimeViewDelegate>
{
    NSString* userId;
    UIView* headerview;
    DetectRecordSegmentedView* recordSegmented;
    
    UIView* timetypeView;
    
    UIViewController* vcRecords;
}
@end

@implementation DetectRecordsStartViewController

- (id) initWithUserId:(NSString*) aUserId
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        userId = aUserId;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 5, self.view.width, 37)];
    [headerview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:headerview];

    UIView* headerline = [[UIView alloc]initWithFrame:CGRectMake(12.5, headerview.height - 0.5, headerview.width - 12.5, 0.5)];
    [headerview addSubview:headerline];
    [headerline setBackgroundColor:[UIColor mainThemeColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self createRecordSegmentedView];
    if (!vcRecords)
    {
        [self createDetectRecordsViewController:0];
    }
    
    
}

- (void)refreshDataWithUserID:(NSString *)userID {
    userId = userID;
    [self createDetectRecordsViewController:recordSegmented.selectedIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) createRecordSegmentedView
{
    if (recordSegmented)
    {
        return;
    }
    
    recordSegmented = [[DetectRecordSegmentedView alloc]initWithFrame:CGRectMake(12.5, 7, 178.5, 30)];
    [headerview addSubview:recordSegmented];
    [recordSegmented setDelegate:self];
}

- (void) createTimeTypeView:(NSInteger) index
{
    if (timetypeView)
    {
        [timetypeView removeFromSuperview];
        timetypeView = nil;
    }
    
    CGRect rtType = CGRectMake(self.view.width - 90, 0, 90, headerview.height);
    switch (index)
    {
        case 1:
        {
            DetectRecordOverallTimeView* overallTimeView = [[DetectRecordOverallTimeView alloc]initWithFrame:rtType];
            timetypeView = overallTimeView;
            [overallTimeView setDelegate:self];
            DetectRecordsSEOverallTableViewController* tvcOverall = (DetectRecordsSEOverallTableViewController*) vcRecords;
            [tvcOverall setTimetype:overallTimeView.selectedTimeType];
        }
            break;
         case 2:
        {
            DetectRecordContrastTimeView* contrastTimeView = [[DetectRecordContrastTimeView alloc]initWithFrame:rtType];
            timetypeView = contrastTimeView;
            [contrastTimeView setDelegate:self];
            DetectRecordsSEContrastTableViewController* tvcContrast = (DetectRecordsSEContrastTableViewController*) vcRecords;
            [tvcContrast setTimetype:contrastTimeView.selectedTimeType];
        }
            break;
        case 0:
        {
            //数值记录 DetectRecordDataSelectedControl
            DetectRecordDataSelectedControl* selectedControl = [[DetectRecordDataSelectedControl alloc]initWithFrame:CGRectMake(headerview.width - 12.5 - 65, headerview.height - 25, 65, 25)];
            timetypeView = selectedControl;
            [selectedControl addTarget:self action:@selector(dataReordControlClicked:) forControlEvents:UIControlEventTouchUpInside];

        }
            break;
        default:
            break;
    }
    
    if (timetypeView)
    {
        [headerview addSubview:timetypeView];
    }
}

- (void) createDetectRecordsViewController:(NSInteger) index
{
    if (vcRecords)
    {
        [vcRecords.view removeFromSuperview];
        [vcRecords removeFromParentViewController];
        vcRecords = nil;
    }
    
    CGRect rtRecords = self.view.bounds;
    rtRecords.origin.y = headerview.bottom;
    rtRecords.size.height = rtRecords.size.height - headerview.bottom;
    
    switch (index)
    {
        case 0:
        {
            //数值记录
            vcRecords = [[DetectDataRecordsViewController alloc]initWithUserId:userId];
        }
            break;
            
        case 1:
        {
            //整体趋势
            vcRecords = [[DetectRecordsSEOverallTableViewController alloc]initWithUserId:userId];
        }
            break;
        case 2:
        {
            //时段对比
            vcRecords = [[DetectRecordsSEContrastTableViewController alloc]initWithUserId:userId];
        }
            break;

        default:
            break;
    }
    
    if (vcRecords)
    {
        [vcRecords.view setFrame:rtRecords];
        [self.view addSubview:vcRecords.view];
        [self addChildViewController:vcRecords];
        [vcRecords didMoveToParentViewController:self];
    }
    
    [self createTimeTypeView:index];
}

#pragma mark - DetectRecordSegmentedDelegate
- (void) segmentedview:(DetectRecordSegmentedView*) segmentedview SelectedIndex:(NSInteger) selectedIndex
{
    if (segmentedview == recordSegmented)
    {
        [self createDetectRecordsViewController:selectedIndex];
    }
}

#pragma mark - DetectRecordTimeViewDelegate
- (void) timeTypeSelected:(DetectTimeType) timetype
{
    NSInteger selectType = recordSegmented.selectedIndex;
    switch (selectType)
    {
        case 0:
        {
            //整体趋势
            DetectRecordsSEOverallTableViewController* tvcOverall = (DetectRecordsSEOverallTableViewController*) vcRecords;
            [tvcOverall setTimetype:timetype];
        }
            break;
        case 1:
        {
            //整体趋势
            DetectRecordsSEContrastTableViewController* tvcConstrast = (DetectRecordsSEContrastTableViewController*) vcRecords;
            [tvcConstrast setTimetype:timetype];
        }
            break;
        case 2:
        {
            //数值记录
            
        }
            break;
        default:
            break;
    }
}

- (void) dataReordControlClicked:(id) sender
{
    if (![sender isKindOfClass:[DetectRecordDataSelectedControl class]])
    {
        return;
    }
    DetectRecordDataSelectedControl* selControl = (DetectRecordDataSelectedControl*) sender;
//    if (selControl.isExpended)
//    {
//        return;
//    }
    
    DetectDataRecordsViewController* tvcDataRecord = (DetectDataRecordsViewController*) vcRecords;
    
    selControl.isExpended = YES;
    [DetectDataRecordTypeSelectedViewController createSelectedControllerInParent:self DataRecordTypeSelectedBlock:^(DetectDataRecordType *type) {
        selControl.isExpended = NO;
        //NSLog(@"DetectDataRecordTypeSelectedViewController %@", type.typeName);
        [tvcDataRecord setKpiCode:type.kpiCode];
        [selControl setSelectedName:type.typeName];
    }];
}
@end

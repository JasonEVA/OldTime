//
//  HMSelectPatientThirdEditionFeeTableViewController.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSelectPatientThirdEditionFeeTableViewController.h"
#import "PatientSearchResultTableViewController.h"
#import "HMNewPatientSelectTableViewCell.h"

@interface HMSelectPatientThirdEditionFeeTableViewController ()<UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic, strong)  PatientSearchResultTableViewController  *resultVC; // <##>
@property (nonatomic, strong)  UISearchController  *searchVC; // <##>
@property (nonatomic, strong)  NSMutableArray *feeDataList;

@end

@implementation HMSelectPatientThirdEditionFeeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _feeSelectedPatients = [NSMutableArray array];
    [self.tableView setTableHeaderView:self.searchVC.searchBar];
    
    self.view.backgroundColor = [UIColor commonBackgroundColor];
    [self.tableView registerClass:[HMNewPatientSelectTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HMNewPatientSelectTableViewCell class])];
    self.tableView.rowHeight = 60;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configPatientsData:(NSArray<PatientInfo *> *)patients {
    self.feeDataList = [NSMutableArray arrayWithArray:patients];
}

- (BOOL) patientIsSelected:(PatientInfo*) patient
{
    if (!_feeSelectedPatients)
    {
        return NO;
    }
    for (PatientInfo* selPatient in _feeSelectedPatients)
    {
        if (selPatient.userId == patient.userId)
        {
            return YES;
        }
    }
    return NO;
}

- (void)hideSearchVC {
    if (self.searchVC.active) {
        self.searchVC.active = NO;
    }
}

- (void)reloadLetterVCWithArray:(NSMutableArray *)array {
    self.feeSelectedPatients = array;
    [self.tableView reloadData];
    self.resultVC.selectedPatientArr = array;
    [self.resultVC.tableView reloadData];
}
#pragma mark - UISearchResultUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    [self.resultVC configWithSourceData:self.feeAllPatients];
    self.resultVC.selectedPatientArr = self.feeSelectedPatients;
    
    NSLog(@"-------------->%@",[NSThread currentThread]);
    if (searchController.searchBar.text.length > 0) {
        __weak typeof(self) weakSelf = self;
        [self.resultVC updateResultsWithKeywords:searchController.searchBar.text resultClicked:^(id resultData) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [searchController.searchBar resignFirstResponder];
            
            [strongSelf setFeeSelectedPatients:strongSelf.resultVC.selectedPatientArr];
            [strongSelf.tableView reloadData];
            
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(HMSelectPatientThirdEditionFeeTableViewControllerDelegateCallBack_feeSelectedPatientChanged)])
            {
                [strongSelf.delegate HMSelectPatientThirdEditionFeeTableViewControllerDelegateCallBack_feeSelectedPatientChanged];
            }
            
            
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feeDataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HMNewPatientSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HMNewPatientSelectTableViewCell class]) forIndexPath:indexPath];
    PatientInfo* patient = self.feeDataList[indexPath.row];
    [cell setIsSelected:[self patientIsSelected:patient]];
    [cell setPatientInfo:patient];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PatientInfo* patient = self.feeDataList[indexPath.row];
    
    if ([self patientIsSelected:patient])
    {
        __weak typeof(self) weakSelf = self;
        [self.feeSelectedPatients enumerateObjectsUsingBlock:^(PatientInfo *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (obj.userId == patient.userId) {
                [strongSelf.feeSelectedPatients removeObject:obj];
            }
        }];
    }
    else
    {
        [self.feeSelectedPatients addObject:patient];
    }
    
    [self.tableView reloadData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(HMSelectPatientThirdEditionFeeTableViewControllerDelegateCallBack_feeSelectedPatientChanged)])
    {
        [self.delegate HMSelectPatientThirdEditionFeeTableViewControllerDelegateCallBack_feeSelectedPatientChanged];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (PatientSearchResultTableViewController *)resultVC {
    if (!_resultVC) {
        _resultVC = [[PatientSearchResultTableViewController alloc] initWithSelectPatientVC];
    }
    return _resultVC;
}
- (UISearchController *)searchVC {
    if (!_searchVC) {
        _searchVC = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
        _searchVC.searchResultsUpdater = self;
        _searchVC.searchBar.delegate = self;
        _searchVC.searchBar.placeholder = @"输入姓名搜索";
        [_searchVC.searchBar sizeToFit];
        [_searchVC.searchBar setBackgroundImage:[UIImage imageColor:[UIColor colorWithHexString:@"f0f0f0"] size:CGSizeMake(1, 1) cornerRadius:0]];
        _searchVC.hidesNavigationBarDuringPresentation = NO;
        self.definesPresentationContext = YES;
    }
    return _searchVC;
}

@end

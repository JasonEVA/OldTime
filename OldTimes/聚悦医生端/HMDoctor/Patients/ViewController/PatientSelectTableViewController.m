//
//  PatientSelectTableViewController.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "PatientSelectTableViewController.h"
@interface PatientSelectTableViewCell : PatientListTableViewCell
{
    UIImageView* ivSelected;
}

- (void) setIsSelected:(BOOL) selected;
@end

@implementation PatientSelectTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ivSelected = [[UIImageView alloc]init];
        [self.contentView addSubview:ivSelected];
        
        [lbComment mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.contentView).with.offset(-35);
        }];
        
        [ivSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20.5, 20.5));
            make.right.equalTo(self.contentView).with.offset(-12.5);
            make.centerY.equalTo(self.contentView);
        }];
        
        
    }
    return self;
}

- (void) setIsSelected:(BOOL) selected
{
    //c_contact_nonSelect c_contact_selected
    if (selected)
    {
        [ivSelected setImage:[UIImage imageNamed:@"c_contact_selected"]];
    }
    else
    {
        [ivSelected setImage:[UIImage imageNamed:@"c_contact_nonSelect"]];
    }
}

@end
@interface PatientSelectTableViewController ()
{
    
}
@end

@implementation PatientSelectTableViewController

- (void)viewDidLoad {
    _selectedPatients = [NSMutableArray array];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString*) cellClassName
{
    NSString* classname = @"PatientSelectTableViewCell";
    return classname;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientSelectTableViewCell* cell = (PatientSelectTableViewCell*) [super tableView:tableView cellForRowAtIndexPath:indexPath];
    PatientInfo* patient = [self patientInfoWithIndex:indexPath];
    [cell setIsSelected:[self patientIsSelected:patient]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PatientInfo* patient = [self patientInfoWithIndex:indexPath];
    if ([self patientIsSelected:patient])
    {
        [_selectedPatients removeObject:patient];
    }
    else
    {
        [_selectedPatients addObject:patient];
    }
    
    [self.tableView reloadData];
    
    if (_selectDelegate && [_selectDelegate respondsToSelector:@selector(selectedPatientChanged)])
    {
        [_selectDelegate selectedPatientChanged];
    }
}

- (BOOL) patientIsSelected:(PatientInfo*) patient
{
    if (!_selectedPatients)
    {
        return NO;
    }
    for (PatientInfo* selPatient in _selectedPatients)
    {
        if (selPatient.userId == patient.userId)
        {
            return YES;
        }
    }
    return NO;
}
@end

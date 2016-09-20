//
//  MLSNMainViewController.m
//  MLScrollingNavbar
//
//  Created by Santiago Lazzari on 9/20/16.
//  Copyright © 2016 SantiagoLazzari. All rights reserved.
//

#import "MLSNMainViewController.h"

#import "MLSNTableViewCell.h"
#import "MLSNScrollingHandler.h"

@interface MLSNMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MLSNScrollingHandler *scrollingHandler;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@end

@implementation MLSNMainViewController

#pragma mark - Navigation
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupScrollingHandler];
}

#pragma mark - Setup
- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    [self.tableView registerClass:[MLSNTableViewCell class] forCellReuseIdentifier:@"SNTableViewController"];
  
}

- (void)setupScrollingHandler {
    self.scrollingHandler = [MLSNScrollingHandler scrollingHandlerWithScrollViewTopConstraint:self.tableViewTopConstraint navbar:self.navigationController.navigationBar scrollView:self.tableView];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SNTableViewController" forIndexPath:indexPath];
    
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor darkGrayColor];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

//#pragma mark - ScrollView
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.scrollingHandler scrollNavbarWithScrollView:self.tableView];
//}

@end

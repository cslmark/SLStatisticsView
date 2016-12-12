//
//  SLMainTableViewController.m
//  SLStatisticGraph
//
//  Created by smart on 16/4/26.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "SLMainTableViewController.h"

@interface SLMainTableViewController ()

@end

@implementation SLMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


@end

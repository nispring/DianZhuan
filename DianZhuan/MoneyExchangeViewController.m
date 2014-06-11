//
//  MoneyExchangeViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "MoneyExchangeViewController.h"
#import "MoneyExchangeDetailViewController.h"
@interface MoneyExchangeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MoneyExchangeViewController

- (void)loadView{
    [super loadView];
    
    UITableView *table = [[UITableView alloc]init];
    [self.view addSubview:table];
    table.frame =  self.view.frame;
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 70.0f;
    table.tableFooterView = [[UIView alloc]init];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    cell.textLabel.text = indexPath.row==0?@"111111":@"222222";
    cell.detailTextLabel.text = indexPath.row==0?@"111111":@"222222";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoneyExchangeDetailViewController *vc = [[MoneyExchangeDetailViewController alloc]initWithNibName:@"MoneyExchangeDetailViewController" bundle:nil];
    vc.type = indexPath.row==0?0:1;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

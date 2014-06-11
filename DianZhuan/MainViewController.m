//
//  MainViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-5.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "MainViewController.h"
#import "CBAppDelegate.h"
#import "MainTapCell.h"
#import "TurntableViewController.h"
#import "ScratchViewController.h"
#import "MoneyExchangeViewController.h"
#import "MoneyDetailViewController.h"
#import "QuestionViewController.h"
#import "TaskListViewController.h"


@interface MainViewController ()

@property (nonatomic,strong)MainTapCell *mainTopCell;
@property (nonatomic,strong)UIRefreshControl *refreshControl;

@end

@implementation MainViewController

- (void)questionChick{
    QuestionViewController *vc = [[QuestionViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadView{
    [super loadView];
    if(IOS_7){
        self.edgesForExtendedLayout = 0;
    }
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(questionChick)];
    self.navigationItem.rightBarButtonItem = rightBar;
    

    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MainTopCell"owner:self options:nil];
    self.mainTopCell = [nib objectAtIndex:0];
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //cell 跳转通知
    [NOTIFICATION_CENTER addObserver:self selector:@selector(PushMoneyExchange) name:@"PushMoneyExchange" object:nil];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(PushMoneyDetail) name:@"PushMoneyDetail" object:nil];

    

}

- (void)PushMoneyDetail{
    MoneyDetailViewController *vc = [[MoneyDetailViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)PushMoneyExchange{
    MoneyExchangeViewController *vc = [[MoneyExchangeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)handleData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd hh:mm"];
    NSString *lastUpdated = [NSString stringWithFormat:@"上次刷新 %@", [formatter stringFromDate:[NSDate date]]];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}


-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在刷新..."];
        [self performSelector:@selector(handleData) withObject:nil afterDelay:1];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if(indexPath.row==0){
            [cell.contentView addSubview:self.mainTopCell];
        }else{
            cell.textLabel.text = @"test1";
        }
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return self.mainTopCell.height;
    }else{
        return 50;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==1){
        TaskListViewController *vc = [[TaskListViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.row == 2){
        ScratchViewController *vc = [[ScratchViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if(indexPath.row == 3){
        TurntableViewController *vc = [[TurntableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    DLog(@"%d",indexPath.row);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

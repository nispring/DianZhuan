//
//  MainViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-5.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "MainViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "CBAppDelegate.h"
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)UITableView *tableView;

@end


@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    [super loadView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 30.0f)];
    [leftBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageWithFileName:@"leftMenu"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if(indexPath.row==0){
            
            cell.textLabel.text = @"first";
        }else{
            cell.textLabel.text = @"hello";
        }
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
#pragma MFSideMenuContainerViewController method
- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}
- (void)showMenu{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

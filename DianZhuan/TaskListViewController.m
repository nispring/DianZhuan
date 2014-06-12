//
//  TaskListViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "TaskListViewController.h"


#import "YouMiWall.h"
#import "YouMiPointsManager.h"

#import "PunchBoxAd.h"

#import "MiidiAdWall.h"

@interface TaskListViewController ()<UITableViewDelegate,UITableViewDataSource,PBOfferWallDelegate,MiidiAdWallShowAppOffersDelegate>

@end

@implementation TaskListViewController

- (void)loadView{
    [super loadView];
    
    UITableView *table = [[UITableView alloc]init];
    [self.view addSubview:table];
    table.dataSource = self;
    table.delegate = self;
    table.frame = self.view.frame;
    table.tableFooterView = [[UIView alloc]init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //有米通知
    [NOTIFICATION_CENTER addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    
    //有米
    [YouMiWall enable];
    [YouMiPointsManager enable];
    
    //触控
    [PBOfferWall sharedOfferWall].delegate = self;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    if(indexPath.row==0){
        cell.textLabel.text = @"有米";
    }
    if(indexPath.row==1){
        cell.textLabel.text = @"触控";
    }
    if(indexPath.row==2){
        cell.textLabel.text = @"米迪";
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        [YouMiWall showOffers:YES didShowBlock:^{
            NSLog(@"已显示");
            } didDismissBlock:^{
            NSLog(@"已退出");
        }];
    }
    if(indexPath.row == 1){
        [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];

    }
    if(indexPath.row == 2){
        [MiidiAdWall showAppOffers:self withDelegate:self];

    }

}

//有米 回调
- (void)pointsGotted:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSNumber *freshPoints = [dict objectForKey:kYouMiPointsManagerFreshPointsKey];
    // freshPoints的积分不应该拿来使用,积分已经被YouMiSDK保存了, 只是用于告知一下用户, 可以通过 [YouMiPointsManager spendPoints:]来使用积分。
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:[NSString stringWithFormat:@"获得%@积分", freshPoints] delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    //    [alert show];
    
    [UIAlertView showAlertViewWithMessage:[NSString stringWithFormat:@"获得%@积分",freshPoints]];
    DLog(@"回调");
}

//触控回调
#pragma mark - PBOfferWallDelegate
/**
 *	@brief	用户完成积分墙任务的回调
 *
 *	@param 	pbOfferWall 	pbOfferWall
 *	@param 	taskCoins 	taskCoins中的元素为NSDictionary类型（taskCoins为空表示无积分返回，为nil表示查询出错）
 *                            键值说明：taskContent  NSString   任务名称
 //                                   coins        NSNumber    赚得金币数量
 *	@param 	error 	taskCoins为nil时有效，查询失败原因
 */
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall queryResult:(NSArray *)taskCoins
          withError:(NSError *)error
{
    NSLog(@"----------%s", __PRETTY_FUNCTION__);
    NSLog(@"用户已经完成的任务：%@", taskCoins);
}

// 积分墙加载错误
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall
loadAdFailureWithError:(PBRequestError *)requestError
{
    NSLog(@"积分墙加载错误----------%s  %@", __PRETTY_FUNCTION__, requestError.localizedDescription);
}


//米迪回调
#pragma mark  MiidiAdWallAwardPointsDelegate

- (void)didReceiveAwardPoints:(NSInteger)totalPoints{
	NSLog(@"didReceiveAwardPoints success! totalPoints=%d",totalPoints);
	[UIAlertView showAlertViewWithMessage:[NSString stringWithFormat:@"奖励积分成功,用户总积分 %d !",totalPoints]];
}

- (void)didFailReceiveAwardPoints:(NSError *)error{
	NSLog(@"didFailReceiveAwardPoints failed!");
	
    [UIAlertView showAlertViewWithMessage:[NSString stringWithFormat:@"奖励积分失败!!"]];
	
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

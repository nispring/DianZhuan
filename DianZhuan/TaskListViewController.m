//
//  TaskListViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskCell.h"

#import "YouMiWall.h"
#import "YouMiPointsManager.h"

#import "PunchBoxAd.h"

#import "DMOfferWallManager.h"

#import "AppConnect.h"
@interface TaskListViewController ()<UITableViewDelegate,UITableViewDataSource,PBOfferWallDelegate,DMOfferWallManagerDelegate>


@property (nonatomic,strong)DMOfferWallManager *dmManager;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,strong)UITableView *table;
@end

@implementation TaskListViewController

- (void)loadView{
    [super loadView];
    self.title = @"任务列表";
    self.dataArray =
  @[@{@"icon":@"icon_youmi@2x",@"title":@"有米平台",@"subTitle":@"200积分=1金币"},
  @{@"icon":@"icon_youmi@2x",@"title":@"触控平台",@"subTitle":@"200积分=1金币"},
  @{@"icon":@"icon_youmi@2x",@"title":@"多盟平台 ",@"subTitle":@"1金币=1金币"},
  @{@"icon":@"icon_youmi@2x",@"title":@"万普平台",@"subTitle":@"200积分=1金币"}];
    
    self.table = [[UITableView alloc]init];
    [self.view addSubview:self.table];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.frame = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT-64);
    self.table.tableFooterView = [[UIView alloc]init];
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
    
    //多盟
    self.dmManager = [[DMOfferWallManager alloc] initWithPublisherID:@"96ZJ056QzeFWrwTBvy"andUserID:nil];
    self.dmManager.delegate = self;
    // !!!:重要：如果需要禁用应用内下载，请将此值设置为YES。
    self.dmManager.disableStoreKit = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOfferClosed:) name:WAPS_OFFER_CLOSED object:nil];
}
//万普通知
-(void)onOfferClosed:(NSNotification*)notifyObj{
    DLog(@"万普通知%@",[notifyObj object]);
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if(cell==nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil] lastObject];
    }
    cell.icon.image = [UIImage imageNamed:_dataArray[indexPath.row][@"icon"]];
    cell.titleLabel.text = _dataArray[indexPath.row][@"title"];
    cell.subTitleLabel.text = _dataArray[indexPath.row][@"subTitle"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:_table cellForRowAtIndexPath:indexPath];
    return cell.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
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
        [_dmManager presentOfferWallWithViewController:self type:eDMOfferWallTypeList];
    }
    if(indexPath.row == 3){
        [AppConnect showOffers:self]; //⽀支持横竖屏⾃自动切换
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

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

#import "ScratchViewController.h"


#import "YouMiWall.h"
#import "YouMiPointsManager.h"

#import "PunchBoxAd.h"

#import "MiidiAdWall.h"

@interface MainViewController ()<PBOfferWallDelegate,MiidiAdWallShowAppOffersDelegate>

@property (nonatomic,strong)MainTapCell *mainTopCell;
@property (nonatomic,strong)UIRefreshControl *refreshControl;

@end

@implementation MainViewController

- (void)loadView{
    [super loadView];
    

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    
    //有米
    [YouMiWall enable];
    [YouMiPointsManager enable];
    
    //触控
    [PBOfferWall sharedOfferWall].delegate = self;

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
    return 5;
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
        [YouMiWall showOffers:YES didShowBlock:^{
            NSLog(@"已显示");
        } didDismissBlock:^{
            NSLog(@"已退出");
        }];
    }
    if(indexPath.row == 2){
        [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];
    } //米迪
    if(indexPath.row == 3){
        [MiidiAdWall showAppOffers:self withDelegate:self];
    }
    if(indexPath.row == 4){
        ScratchViewController *vc = [[ScratchViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    DLog(@"%d",indexPath.row);
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

@end

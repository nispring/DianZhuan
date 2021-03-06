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
#import "ShareViewController.h"
#import "TaskCell.h"

#import "YouMiWall.h"
#import "YouMiPointsManager.h"
#import "PunchBoxAd.h"
#import "DMOfferWallManager.h"
#import "AppConnect.h"
#import "MopanAdWall.h"

#import "RNGridMenu.h"
@interface MainViewController ()<PBOfferWallDelegate,DMOfferWallManagerDelegate,MopanAdWallDelegate,RNGridMenuDelegate>

@property (nonatomic,strong)DMOfferWallManager *dmManager;
@property (nonatomic,)MopanAdWall *MopanAdWall;
@property (nonatomic,strong)MainTapCell *mainTopCell;
@property (nonatomic,strong)TaskCell *taskCell;

@property (nonatomic,strong)UIRefreshControl *refreshControl;
@property (nonatomic,strong)NSArray *dataArray;

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

    self.title = @"金手指";
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"问题" style:UIBarButtonItemStyleDone target:self action:@selector(questionChick)];
    self.navigationItem.rightBarButtonItem = bar;
    
    self.dataArray =
    @[@{@"icon":@"icon_youmi@2x",@"title":@"任务平台",@"subTitle":@"快来赚取积分吧"},
      @{@"icon":@"icon_youmi@2x",@"title":@"分享",@"subTitle":@"分享给好友，轻松得积分"},
      @{@"icon":@"icon_youmi@2x",@"title":@"大转盘 "
        ,@"subTitle":@"转一转，人品大爆发"},
      @{@"icon":@"icon_youmi@2x",@"title":@"刮刮乐"
        ,@"subTitle":@"快来试试手气吧"}];

    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor grayColor];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //有米
    [YouMiWall enable];
    [YouMiPointsManager enable];
    [NOTIFICATION_CENTER addObserver:self selector:@selector(pointsGotted:) name:kYouMiPointsManagerRecivedPointsNotification object:nil];
    
    //触控
    [PBOfferWall sharedOfferWall].delegate = self;
    
    //多盟
    self.dmManager = [[DMOfferWallManager alloc] initWithPublisherID:@"96ZJ056QzeFWrwTBvy"andUserID:nil];
    self.dmManager.delegate = self;
    
    //万普
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetPointsSuccess:) name:WAPS_GET_POINTS_SUCCESS object:nil];
    
    //磨盘
    self.MopanAdWall = [[MopanAdWall alloc]initWithMopan:@"12703" withAppSecret:@"5vvayxpa9vfk3osl"];
    self.MopanAdWall.delegate = self;

    [self queryIntegral];
    
    //刷新当前积分
    [NOTIFICATION_CENTER addObserver:self selector:@selector(UpdateIntegral) name:@"UpdateIntegral" object:nil];
    
    //首次进入自动刷新
    [self.tableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self.refreshControl beginRefreshing];
    [self refreshView:self.refreshControl];
}

- (void)queryIntegral{
    //有米
    [YouMiPointsManager checkPoints];
    //触控
    [[PBOfferWall sharedOfferWall] queryRewardCoin:nil];
    //多盟
    [_dmManager checkOwnedPoint];
    //万普
    [AppConnect getPoints];
    //磨盘
    [_MopanAdWall getMoney];
}

- (void)UpdateIntegral{
    _mainTopCell.integralLabel.text = [CBKeyChain load:TOTOLINTEGRAL];
}
- (void)topCellChick:(UIButton *)sender{
    MoneyDetailViewController *vc1 = [[MoneyDetailViewController alloc]init];
    MoneyExchangeViewController *vc2 = [[MoneyExchangeViewController alloc]init];
    [self.navigationController pushViewController:sender.tag==100?vc1:vc2 animated:YES];
}

-(void)handleData
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd hh:mm"];
    NSString *lastUpdated = [NSString stringWithFormat:@"上次刷新 %@", [formatter stringFromDate:[NSDate date]]];
    [self UpdateIntegral];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        if(indexPath.row==0){
            NSArray *MainTopNib = [[NSBundle mainBundle]loadNibNamed:@"MainTopCell"owner:self options:nil];
            self.mainTopCell = [MainTopNib objectAtIndex:0];
            self.mainTopCell.integralLabel.text = [CBKeyChain load:TOTOLINTEGRAL];
            self.mainTopCell.detailBtn.tag = 100;
            self.mainTopCell.extractBtn.tag = 101;
            [self.mainTopCell.detailBtn addTarget:self action:@selector(topCellChick:) forControlEvents:UIControlEventTouchUpInside];
            [self.mainTopCell.extractBtn addTarget:self action:@selector(topCellChick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:_mainTopCell];
        }else{
            TaskCell *taskCell = [[[NSBundle mainBundle] loadNibNamed:@"TaskCell" owner:self options:nil] lastObject];
            taskCell.icon.image = [UIImage imageNamed:_dataArray[indexPath.row-1][@"icon"]];
            taskCell.titleLabel.text = _dataArray[indexPath.row-1][@"title"];
            taskCell.subTitleLabel.text = _dataArray[indexPath.row-1][@"subTitle"];
            return taskCell;
        }
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return _mainTopCell.height;
    }else{
        return 70;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 1:
            [self showGrid];
            break;
        case 2:
        {
            ShareViewController *share=[[ShareViewController alloc]init];
            [self.navigationController pushViewController:share animated:NO];
            break;
        }
        case 3:
        case 4:;
            UIViewController *vc;
            indexPath.row==3?(vc = [[TurntableViewController alloc]init]):(vc = [[ScratchViewController alloc]init]);
            [self.navigationController pushViewController:vc animated:YES];
            break;
    }
}
- (void)showGrid {
    NSInteger numberOfOptions = 5;
    NSArray *items = @[
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_youmi@2x"] title:@"有米"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_youmi@2x"] title:@"触控"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_youmi@2x"] title:@"多盟"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_youmi@2x"] title:@"万普"],
                       [[RNGridMenuItem alloc] initWithImage:[UIImage imageNamed:@"icon_youmi@2x"] title:@"磨盘"]
                       ];
    
    RNGridMenu *av = [[RNGridMenu alloc] initWithItems:[items subarrayWithRange:NSMakeRange(0, numberOfOptions)]];
    av.delegate = self;
    //    av.bounces = NO;
    [av showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height/2.f)];
}
- (void)gridMenu:(RNGridMenu *)gridMenu willDismissWithSelectedItem:(RNGridMenuItem *)item atIndex:(NSInteger)itemIndex {
    NSLog(@"Dismissed with item %d: %@", itemIndex, item.title);
    switch (itemIndex) {
        case 0:
            [YouMiWall showOffers:YES didShowBlock:^{
                NSLog(@"已显示");
            } didDismissBlock:^{
                    NSLog(@"已退出");
            }];
            break;
        case 1:
            [[PBOfferWall sharedOfferWall] showOfferWallWithScale:0.9f];
            break;
        case 2:
            [_dmManager presentOfferWallWithViewController:self type:eDMOfferWallTypeList];
            break;
        case 3:
            [AppConnect showOffers:self];
            break;
        case 4:
            [_MopanAdWall showAppOffers];
            break;
    }

}


//有米 回调
- (void)pointsGotted:(NSNotification *)notification {
    [YouMiPointsManager pointsRemained];
    DLog(@"有米总积分：%d",*[YouMiPointsManager pointsRemained]);
}

//触控回调
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
    int totalCoins=0;
    for(NSDictionary *dic in taskCoins){
        totalCoins += [dic[@"coins"]intValue];
    }
    DLog(@"触控总积分:%d",totalCoins);
}
//多盟
// 积分查询成功之后,回调该接⼝口,获取总积分和总已消费积分。
- (void)dmOfferWallManager:(DMOfferWallManager *)manager
        receivedTotalPoint:(NSNumber *)totalPoint
        totalConsumedPoint:(NSNumber *)consumedPoint{
    
    DLog(@"多盟总积分：%@",totalPoint);
}

//万普通知
-(void)onGetPointsSuccess:(NSNotification*)notifyObj{
    WapsUserPoints *userPoints = notifyObj.object;
    NSLog(@"万普总积分:%d", [userPoints getPointsValue]);
}

//磨盘
// 请求积分值成功后调用
//
// 详解:当接收服务器返回的积分值成功后调用该函数
// 补充：totalMoney: 返回用户的总积分
//      moneyName  : 返回的积分名称
- (void)adwallSuccessGetMoney:(NSInteger)totalMoney forMoneyName:(NSString*)moneyName
{
    NSLog(@"磨盘总积分：%d",(int)totalMoney);
}
- (void)adwallDidShowAppsStartLoad{
    
}
- (void)adwallDidShowAppsClosed{
    
}

- (void)updateIntegralWithADType:(int)adType andIntegral:(NSString *)newIntegral{
    NSString *oldIntegral;
    NSString *adName;
    NSString *adId;
    //有米（1）触控（2）多盟（3）万普（4）磨盘（5）
    switch (adType) {
        case 1:
            oldIntegral = [CBKeyChain load:YOUMI];
            adName = @"有米平台";
            adId = YOUMI;
            break;
        case 2:
            oldIntegral = [CBKeyChain load:CHUKONG];
            adName = @"触控平台";
            adId = CHUKONG;
            break;
        case 3:
            oldIntegral = [CBKeyChain load:DUOMENG];
            adName = @"多盟平台";
            adId = DUOMENG;
            break;
        case 4:
            oldIntegral = [CBKeyChain load:WANPU];
            adName = @"万普平台";
            adId = WANPU;
            break;
        case 5:
            oldIntegral = [CBKeyChain load:MOPAN];
            adName = @"磨盘平台";
            adId = MOPAN;
            break;
    }
    //如果该平台获取到得积分大于keychai中积分
    NSString *subStr = [NSString stringWithFormat:@"%d",[newIntegral intValue]>[oldIntegral intValue]];
    if(subStr > 0){
        //保存在keychain
        NSString *newTotalIntegral = [NSString stringWithFormat:@"%d",[[CBKeyChain load:TOTOLINTEGRAL] intValue]+[subStr intValue]];
        [CBKeyChain save:TOTOLINTEGRAL data:newTotalIntegral];
        [CBKeyChain save:adId data:newIntegral];
        [[RecordManager sharedRecordManager] updateRecordWithContent:adName andIntegral:[NSString stringWithFormat:@"+%@",subStr]];
        
        //更新bmob Users表
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"Users"];
        [bquery getObjectInBackgroundWithId:[CBKeyChain load:USERID] block:^(BmobObject *object,NSError *error){
            if (!error) {
                if (object) {
                    [object setObject:subStr forKey:adId];
                    [object setObject:newTotalIntegral forKey:TOTOLINTEGRAL];
                    [object updateInBackground];
                }
            }else{
            }
        }];
        
        //上传bmob IncomeRecord表
        BmobObject *gameScore = [BmobObject objectWithClassName:@"IncomeRecord"];
        [gameScore setObject:[CBKeyChain load:USERID] forKey:@"userId"];
        [gameScore setObject:adName forKey:@"adType"];
        [gameScore setObject:subStr forKey:@"integral"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
        }];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

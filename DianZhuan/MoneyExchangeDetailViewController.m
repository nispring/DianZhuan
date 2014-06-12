//
//  MoneyExchangeDetailViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-11.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "MoneyExchangeDetailViewController.h"

@interface MoneyExchangeDetailViewController ()<UIActionSheetDelegate>

@end

@implementation MoneyExchangeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //支付宝
    if(_type==1){
        _label1.text = @"111111";
        _label2.text = @"222222";
        _label3.text = @"支付宝账号";
        _label4.text = @"兑换金额";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SelectChick:(id)sender {
    [_inputTF resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"test", nil];
    [sheet showInView:self.view];
}
- (IBAction)PutChick:(id)sender {

}
@end

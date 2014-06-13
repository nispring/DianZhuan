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
    self.selectBTN.backgroundColor = [UIColor whiteColor];
    //支付宝
    if(_type==1){
        self.label1.text = @"最快24小时到账";
        self.label2.text = @"账   号:";
        self.label3.text = @"提现金额:";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SelectChick:(id)sender {
    [_inputTF resignFirstResponder];
    UIActionSheet *sheet;
    if(_type==1){
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"10元 = 10金币",@"30元 = 28金币",@"50元 = 46金币",@"100元 = 90金币", nil];

    }else{
        sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"10元话费 = 10金币",@"30元话费 = 28金币",@"50元话费 = 46金币",@"100元话费 = 90金币", nil];
    }
    [sheet showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *str;
    if(buttonIndex==0) str = @"10元";
    if(buttonIndex==1) str = @"30元";
    if(buttonIndex==2) str = @"50元";
    if(buttonIndex==3) str = @"100元";
    [self.selectBTN setTitle:str forState:UIControlStateNormal];
}
- (IBAction)PutChick:(id)sender {
    if(self.inputTF.text.length<1||self.selectBTN.titleLabel.text.length<1){
        [UIAlertView showAlertViewWithMessage:@"请完整填写"];
        return;
    }
    if(![self.inputTF.text isPhoneNumber]){
        [UIAlertView showAlertViewWithMessage:@"手机号格式错误"];
        return;
    }
}
@end

//
//  FatherViewController.m
//  DianZhuan
//
//  Created by 时代合盛 on 14-6-5.
//  Copyright (c) 2014年 时代合盛. All rights reserved.
//

#import "FatherViewController.h"

@interface FatherViewController ()

@end

@implementation FatherViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithStr:@"edf1f2"];
    
    if(IOS_7){
        self.edgesForExtendedLayout = 0;
    }

    //添加手势识别
    [self moveToRight];
}

#pragma mark - uigesture
- (void)moveToRight{
    if([self.navigationController respondsToSelector:@selector(popToViewController:animated:)]){
        
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self.view addGestureRecognizer:recognizer];
    }
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    //左滑
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
    }
    //右滑
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        if([self.navigationController respondsToSelector:@selector(popViewControllerAnimated:)]){
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    //下滑
    if (recognizer.direction==UISwipeGestureRecognizerDirectionDown){
    }
    //上滑动
    if (recognizer.direction==UISwipeGestureRecognizerDirectionUp){
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

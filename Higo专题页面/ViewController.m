//
//  ViewController.m
//  Higo专题页面
//
//  Created by 宓珂璟 on 16/6/16.
//  Copyright © 2016年 宓珂璟. All rights reserved.
//

#import "ViewController.h"
#import "CountrySessionViewController.h"
#import "UINavigationController+StatusBarStyle.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)click:(UIButton *)sender
{
    CountrySessionViewController *session = [[CountrySessionViewController alloc] init];
    [self.navigationController pushViewController:session animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

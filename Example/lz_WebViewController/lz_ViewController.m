//
//  lz_ViewController.m
//  lz_WebViewController
//
//  Created by liyouleo911 on 06/22/2018.
//  Copyright (c) 2018 liyouleo911. All rights reserved.
//

#import "lz_ViewController.h"
#import "lz_WebViewController.h"

@interface lz_ViewController ()

@end

@implementation lz_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushBtnTapped:(id)sender {
    
    lz_WebViewController *webVC = [[lz_WebViewController alloc] initWithUrlString:@"http://www.baidu.com"];
    [self.navigationController pushViewController:webVC animated:YES];
}

@end

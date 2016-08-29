//
//  StartViewController.m
//  2048
//
//  Created by DMY on 16/4/26.
//  Copyright © 2016年 com.wudong. All rights reserved.
//

#import "StartViewController.h"
#import "SingleViewController.h"
#import "OnlineViewController.h"

#define DMYScreenW [UIScreen mainScreen].bounds.size.width
#define DMYScreenH [UIScreen mainScreen].bounds.size.height

@interface StartViewController ()

@end

@implementation StartViewController
- (IBAction)singleGame:(id)sender {
    SingleViewController *play = [[SingleViewController alloc]init];
//    play.view.frame = CGRectMake(0, 64, DMYScreenW - 64, DMYScreenH);
    [self.navigationController pushViewController:play animated:YES];
//    [self presentViewController:play animated:YES completion:nil];
}
- (IBAction)onlineGame:(id)sender {
//    SZBlueTooth *blueTooth = [[SZBlueTooth alloc]init];
//    [blueTooth connect];
    OnlineViewController *online = [[OnlineViewController alloc]init];
    [self.navigationController pushViewController:online animated:YES];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

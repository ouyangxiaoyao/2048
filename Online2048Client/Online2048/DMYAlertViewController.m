//
//  DMYAlertViewController.m
//  Online2048
//
//  Created by 董梦瑶 on 16/5/20.
//  Copyright © 2016年 董梦瑶. All rights reserved.
//

#import "DMYAlertViewController.h"

@interface DMYAlertViewController ()

@end

@implementation DMYAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.winnerLabel.text = self.str;

}
-(void)setStr:(NSString *)str
{
    _str = str;
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

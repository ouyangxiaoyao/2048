//
//  DMYAlertViewController.h
//  Online2048
//
//  Created by 董梦瑶 on 16/5/20.
//  Copyright © 2016年 董梦瑶. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMYAlertViewController : UIViewController
@property(nonatomic,copy)NSString *str;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
- (IBAction)close:(id)sender;

@end

//
//  SetView.h
//  Online2048
//
//  Created by DMY on 16/4/30.
//  Copyright © 2016年 DMY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^againGame)();

@interface SetView : UIView

@property (nonatomic,strong) againGame block1;
@property (nonatomic,strong) againGame block2;


- (IBAction)reStart:(UIButton *)sender;


- (IBAction)continueGame:(UIButton *)sender;

- (IBAction)gameHelp:(UIButton *)sender;
- (IBAction)VoiceSwitch:(UISwitch *)sender;







@end


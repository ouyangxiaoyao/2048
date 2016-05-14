//
//  SetView.m
//  Online2048
//
//  Created by DMY on 16/4/30.
//  Copyright © 2016年 DMY. All rights reserved.
//

#import "SetView.h"
#import "SingleViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "XMGAudioTool.h"
@interface SetView()

@end
@implementation SetView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)reStart:(UIButton *)sender
{
    _block1();
    [self removeFromSuperview];
    

}

- (IBAction)continueGame:(UIButton *)sender
{
    
    [self removeFromSuperview];
   
}

- (IBAction)gameHelp:(UIButton *)sender
{
 
    _block2();
    [self removeFromSuperview];
  
}



- (IBAction)VoiceSwitch:(UISwitch *)sender {
    
    if (sender.isOn) {
        [XMGAudioTool playMusicWithMusicName:@"This Kiss.mp3"];
        
    }else{
        [XMGAudioTool stopMusicWithMusicName:@"This Kiss.mp3"];
    }
    
}










@end

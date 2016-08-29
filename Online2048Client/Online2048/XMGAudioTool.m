//
//  XMGAudioTool.m
//  02-播放音效
//
//  Created by xiaomage on 15/8/15.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "XMGAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation XMGAudioTool

static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_players;

+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
    _players = [NSMutableDictionary dictionary];
}

+ (void)playMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);
    
    // 1.定义播放器
    AVAudioPlayer *player = nil;
    
    // 2.从字典中取player,如果取出出来是空,则对应创建对应的播放器
    player = _players[musicName];
    if (player == nil) {
        // 2.1.获取对应音乐资源
        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        
        if (fileUrl == nil) return;
        
        // 2.2.创建对应的播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
        
        // 2.3.将player存入字典中
        [_players setObject:player forKey:musicName];
        
        // 2.4.准备播放
        [player prepareToPlay];
    }
    
    // 3.播放音乐
    [player play];
}

+ (void)pauseMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);
    
    // 1.取出对应的播放
    AVAudioPlayer *player = _players[musicName];
    
    // 2.判断player是否nil
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);
    
    // 1.取出对应的播放
    AVAudioPlayer *player = _players[musicName];
    
    // 2.判断player是否nil
    if (player) {
        [player stop];
        [_players removeObjectForKey:musicName];
        player = nil;
    }
}


@end

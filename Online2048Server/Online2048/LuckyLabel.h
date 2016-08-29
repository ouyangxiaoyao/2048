//
//  LuckyLabel.h
//  Online2048
//
//  Created by DMY on 16/4/30.
//  Copyright © 2016年 DMY. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface LuckyLabel : UILabel

@property (nonatomic) NSInteger numberTag;
@property (nonatomic) NSInteger placeTag;
@property (nonatomic) BOOL canAdd;

-(void)luckyLableColor;

-(void)onlineLuckyLableColor;
@end

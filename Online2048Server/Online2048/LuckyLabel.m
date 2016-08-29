//
//  LuckyLabel.m
//  Online2048
//
//  Created by DMY on 16/4/30.
//  Copyright © 2016年 DMY. All rights reserved.
//

#import "LuckyLabel.h"
@implementation LuckyLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:30];

    }
    return self;
}

-(void)luckyLableColor
{
    self.backgroundColor=[UIColor colorWithRed:248/255.f green:0.5*(1-cos(3.14/6*log2(_numberTag))) blue:0.5*(1-cos(3.14*5/13*log2(_numberTag))) alpha:1];
}
-(void)onlineLuckyLableColor
{
    self.backgroundColor=[UIColor whiteColor];
}
@end


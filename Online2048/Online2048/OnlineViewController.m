//
//  OnlineViewController.m
//  Online2048
//
//  Created by DMY on 16/5/5.
//  Copyright © 2016年 DMY. All rights reserved.
//

#import "OnlineViewController.h"
#import "LuckyLabel.h"
@interface OnlineViewController ()
{
    CGRect _frame;
    //luckyLable的属性
    //高度
    CGFloat _height;
    //宽度
    CGFloat _width;
    //宽度的空隙
    CGFloat _widthGap;
    //高的空隙
    CGFloat _heightGap;
    
    long _coreAdd;
    long _core;
}

#warning 先将初始化时的界面搭建好，再看逻辑问题，，不难的，，加油


@end

@implementation OnlineViewController
-(NSArray *)labelArray
{
    if (_labelArray == nil) {
        _labelArray = @[@"2",@"4",@"8",@"16",@"32",@"64",@"128",@"256",@"512",@"1024",@"2048"];
    }
    return _labelArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    添加手势
    [self addGesture];
    [self setDada];
//    初始化游戏
//    [self againGame];
   }
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBegin];
}
-(void)setBegin
{
    //第一个小的uiView的frame
    _frame=[self.view viewWithTag:100].frame;
    //背景uiview的frame
    CGRect fra=[self.view viewWithTag:101].frame;
    
    _width=fra.size.width;
    _height=fra.size.height;
    _widthGap=fra.origin.x;
    _heightGap=fra.origin.y;
    int labelX = 30;
    int labelY = 250;
    int margin = 10;
    for (int i = 0; i<4; i++) {
        for (int j=0; j<4; j++) {
            if ((i == 0 && j == 3) || (i == 0 && j == 0) ) {
                UILabel *label = [[UILabel alloc]init];
                label.text=@"2";
                label.font = [UIFont systemFontOfSize:30];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor whiteColor];
                if (j==0) {
                    label.backgroundColor = [UIColor redColor];
                }
                
                label.frame= CGRectMake(labelX, labelY + margin* (j+1) + _height*j, _width, _height);
                [self.view addSubview:label];
            }else if ((i==3 && j==0) ||(i==3 && j==3))
            {
                UILabel *label = [[UILabel alloc]init];
                label.text=@"2";
                label.font = [UIFont systemFontOfSize:30];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor blueColor];
                if (j==0) {
                    label.backgroundColor = [UIColor whiteColor];
                }
                
                label.frame= CGRectMake(labelX + i * (_width + margin), labelY + margin* (j+1) + _height*j, _width, _height);
                [self.view addSubview:label];
            }else if ((i==1 && j==2) || (i==2 && j==1)){
                UILabel *label = [[UILabel alloc]init];
                label.text=@"2";
                label.font = [UIFont systemFontOfSize:30];
                label.textAlignment = NSTextAlignmentCenter;
                label.backgroundColor = [UIColor blueColor];
                if (j==1) {
                    label.backgroundColor = [UIColor redColor];
                }
                
                label.frame= CGRectMake(labelX + i * (_width + margin), labelY + margin* (j+1) + _height*j, _width, _height);
                [self.view addSubview:label];

            }
            
        }
    }
   
    
}

-(void)setDada
{
    
    _core=0;
    _coreAdd=0;
    [self scoreNumber];
    _gestureArray=[[NSMutableArray alloc]init];
    //十份位代表列 个位代表行
    _emptyPlaceArray =  [NSMutableArray arrayWithObjects:
                         [NSNumber numberWithInteger:11],
                         [NSNumber numberWithInteger:21],
                         [NSNumber numberWithInteger:31],
                         [NSNumber numberWithInteger:41],
                         [NSNumber numberWithInteger:12],
                         [NSNumber numberWithInteger:22],
                         [NSNumber numberWithInteger:32],
                         [NSNumber numberWithInteger:42],
                         [NSNumber numberWithInteger:13],
                         [NSNumber numberWithInteger:23],
                         [NSNumber numberWithInteger:33],
                         [NSNumber numberWithInteger:43],
                         [NSNumber numberWithInteger:14],
                         [NSNumber numberWithInteger:24],
                         [NSNumber numberWithInteger:34],
                         [NSNumber numberWithInteger:44],
                         nil];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _currentExistArray = [NSMutableArray arrayWithCapacity:16];
    if ([defaults objectForKey:@"currentDic"]) {
        NSDictionary *dic=[defaults objectForKey:@"currentDic"];
        _currentArray=[[dic objectForKey:@"currentArray"]mutableCopy];
     
        //依据_currentArray 填充游戏界面
        [self startGameWithLastMessage];
        
        _core=[[dic objectForKey:@"core"] integerValue];
        [self scoreNumber];
    }else{
        _currentArray=[NSMutableArray arrayWithCapacity:16];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_currentArray,@"currentArray",@"0",@"core", nil];
        [defaults setObject:dic forKey:@"currentDic"];
        [defaults synchronize];
        [self firstBornLabel];
    }
   
    [self resetGameState];

}
#pragma mark --重新开始游戏时需要添加的两个lable
-(void)firstBornLabel
{
//    NSInteger k = 0;//记录第一次产生的数据
//    for (NSInteger i=0; i<2; i++) {
//        NSInteger random;
//        random=arc4random()%(self.emptyPlaceArray.count-1);
//        if (i==0) {
//            k=random;
//        }else {//防止第一次和第二次重合了
//            while (k==random) {
//                random=arc4random()%(self.emptyPlaceArray.count-1);
//            }
//        }
//        NSInteger random2=arc4random()%2;
//        [self addLuckyLabel:random WithNum:[[_labelArray objectAtIndex:random2] integerValue]];
//        [self setCurrentArray];
//    }
}

#pragma mark -- 记录所获得的分数
-(void)scoreNumber
{
    _myScore.text=[NSString stringWithFormat:@"%ld",_core];
}
#pragma mark --依据_currentArray 填充游戏界面 及同步emptyArray与currentExistArray
-(void)startGameWithLastMessage
{
    for (NSDictionary *dic in _currentArray) {
        //        NSLog(@"%@",dic);
        NSInteger random=[_emptyPlaceArray indexOfObject:[dic objectForKey:@"placeTag"]];
        [self addLuckyLabel:random WithNum:[[dic objectForKey:@"numberTag"] integerValue]];
    }
//    [self setEmptyArray];
}
#pragma mark --通过位置数字和值产生lable 同步_currentExistArray
-(void)addLuckyLabel:(NSInteger)random WithNum:(NSInteger)num
{
    LuckyLabel *lable=[[LuckyLabel alloc]init];
    NSNumber *place=[self.emptyPlaceArray objectAtIndex:random];
    lable.placeTag=[place intValue];
    
//    NSDictionary *dic=[self caculatePosition:place];
//    lable.frame=CGRectMake([[dic objectForKey:kPlaceX] intValue], [[dic objectForKey:kPlaceY] intValue], _width, _height);
    lable.numberTag=num;
    lable.text=[NSString stringWithFormat:@"%ld",(long)num];
    lable.canAdd=YES;
    lable.alpha=0.0;
    [lable luckyLableColor];
    [_currentExistArray addObject:lable];
    [self.view addSubview:lable];
    [UIView animateWithDuration:0.4 animations:^{
        lable.alpha=1;
    }];
}

#pragma mark --每次滑动前的初始化
-(void)resetGameState
{
    _canBornNewLabel=NO;
    _isOver = NO;
    for (LuckyLabel *label in _currentExistArray) {
        label.canAdd=YES;
    }
}
#pragma mark --进入游戏时添加手势
-(void)addGesture
{
    UISwipeGestureRecognizer *swipe;
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    swipe.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipe];
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    swipe.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe];
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    swipe.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
}
#pragma mark --每次滑动触发的方法
-(void)swipeFrom:(UISwipeGestureRecognizer *)swipe
{
    
}
#pragma mark --重新开始游戏
-(void)againGame
{
    for (LuckyLabel *lable in _currentExistArray) {
        [lable removeFromSuperview];
    }
    [self deleteLastGame];
    [_currentArray removeAllObjects];

}
#pragma mark -- 清空NSUserDefaults中上次的记录
-(void)deleteLastGame
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"currentDic"];
    
    [defaults synchronize];
}


















































- (IBAction)onlineSetting:(id)sender {
    
}


@end

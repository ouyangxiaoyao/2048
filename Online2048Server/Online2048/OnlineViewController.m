//
//  OnlineViewController.m
//  Online2048
//
//  Created by DMY on 16/5/5.
//  Copyright © 2016年 DMY. All rights reserved.
//

#import "OnlineViewController.h"
#import "LuckyLabel.h"
#import "XMGAudioTool.h"
#import <GCDAsyncSocket.h>

#define kPlaceX @"X"
#define kPlaceY @"Y"


@interface OnlineViewController ()<UIAlertViewDelegate>
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
    
    NSString *_opponentID;
    
    long _coreAdd;
    long _core;
}

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;
@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
#warning 先将初始化时的界面搭建好，再看逻辑问题，，不难的，，加油


@end

@implementation OnlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    添加手势
    [self addGesture];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self againGame];
    
}
#pragma mark --重新开始游戏
-(void)againGame
{
    for (LuckyLabel *lable in _currentExistArray) {
        [lable removeFromSuperview];
    }
    [self deleteLastGame];
    
    [_currentArray removeAllObjects];
    [self setDada];
    
    
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
                LuckyLabel *label1 = [[LuckyLabel alloc]init];
                label1.text=@"2";
                label1.numberTag = 2;
//                十分位代表列，个位代表行
//                label1.placeTag = (i+1) * 10 + (j+1);
                label1.placeTag = 14;
                if (j==0) {
                    label1.backgroundColor = [UIColor redColor];
                    label1.placeTag = 11;
                }
                
                label1.frame= CGRectMake(labelX, labelY + margin* (j+1) + _height*j, _width, _height);
                [self.view addSubview:label1];
                [_currentExistArray addObject:label1];
//                [self addLuckyLabel:12 WithNum:2 withColor:[UIColor blueColor]];
//                [self addLuckyLabel:0 WithNum:2 withColor:[UIColor redColor]];
            }else if ((i==3 && j==0) ||(i==3 && j==3))
            {
                LuckyLabel *label2 = [[LuckyLabel alloc]init];
                label2.text=@"2";
                label2.numberTag = 2;
//                label2.placeTag = (i+1) * 10 + (j+1);
                label2.placeTag = 44;
                label2.backgroundColor = [UIColor blueColor];
                if (j==0) {
                    label2.backgroundColor = [UIColor whiteColor];
                    label2.placeTag = 41;
                }
                label2.frame= CGRectMake(labelX + i * (_width + margin), labelY + margin* (j+1) + _height*j, _width, _height);
                [self.view addSubview:label2];
                [_currentExistArray addObject:label2];

            }else if ((i==1 && j==2) || (i==2 && j==1))
            {
                LuckyLabel *label = [[LuckyLabel alloc]init];
                label.text=@"2";
                label.numberTag =2;
//                label.placeTag = (j+1) * 10 + (i+1);
                label.placeTag = 23;
                label.backgroundColor = [UIColor blueColor];
                if (j==1) {
                    label.backgroundColor = [UIColor redColor];
                    label.placeTag = 32;

                }
                
                label.frame= CGRectMake(labelX + i * (_width + margin), labelY + margin* (j+1) + _height*j, _width, _height);
                [self.view addSubview:label];
                [_currentExistArray addObject:label];

            }
            
        }
    }
//    for (LuckyLabel *label in _currentExistArray) {
//        NSLog(@"%@ %lu %lu",label.text,label.placeTag,label.numberTag);
//    }
////    去除_emptyPlaceArray中的label，
//    for (LuckyLabel *label in _currentExistArray) {
//        if (_emptyPlaceArray) {
//            [_emptyPlaceArray removeObject:[NSNumber numberWithInteger:label.placeTag]];
//        }
//        
//    }
//    NSLog(@"------------------%@",_emptyPlaceArray);
//   
//    把_currentExistArray中的数填充到_currentArray中
    [self setCurrentArray];
    
}
#pragma mark --把_currentExistArray中的数填充到_currentArray中
-(void)setCurrentArray
{
//    去除_currentArray之前存储的数据
  
    [_currentArray removeAllObjects];
    for (LuckyLabel *lable in _currentExistArray) {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:lable.placeTag],@"placeTag",[NSNumber numberWithInteger:lable.numberTag],@"numberTag", nil];
//        _currentArray存储的是字典，字典的键是label的数字标签，值是label的位置
        [_currentArray addObject:dic];
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_currentArray,@"currentArray",_myScore.text,@"core", nil];
    [defaults setObject:dic forKey:@"currentDic"];
   
    [defaults synchronize];
}

-(void)setDada
{
    
    _core=0;
    _coreAdd=0;
    [self scoreNumber];
    
    _labelArray = [NSArray arrayWithObjects:
                   [NSNumber numberWithInteger:2],
                   [NSNumber numberWithInteger:4],
                   nil];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
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
        [self setBegin];
    }
   
    [self resetGameState];

}

#warning 分数记录有问题，加油加油。。怎样只记录蓝方或红方的分数
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
        NSLog(@"dic %@",[dic objectForKey:@"placeTag"]);
        [self addLuckyLabel:random WithNum:[[dic objectForKey:@"numberTag"] integerValue]];
    }
     [self setEmptyArray];
}

#pragma mark --找出空的位置
-(void)setEmptyArray
{
    [self.emptyPlaceArray removeAllObjects];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:11]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:21]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:31]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:41]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:12]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:22]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:32]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:42]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:13]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:23]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:33]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:43]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:14]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:24]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:34]];
    [self.emptyPlaceArray addObject:[NSNumber numberWithInteger:44]];
    for (LuckyLabel *label in self.currentExistArray) {
        [self.emptyPlaceArray removeObject:[NSNumber numberWithInteger:label.placeTag]];
    }
}

#pragma mark --通过位置数字和值产生lable 同步_currentExistArray
-(void)addLuckyLabel:(NSInteger)random WithNum:(NSInteger)num
{
    LuckyLabel *lable=[[LuckyLabel alloc]init];
#warning 崩掉
    NSLog(@"random  %lu",random);
    NSNumber *place=[self.emptyPlaceArray objectAtIndex:random];
    lable.placeTag=[place intValue];
    
    NSDictionary *dic=[self caculatePosition:place];
    lable.frame=CGRectMake([[dic objectForKey:kPlaceX] intValue], [[dic objectForKey:kPlaceY] intValue], _width, _height);
    lable.numberTag=num;
    lable.text=[NSString stringWithFormat:@"%ld",(long)num];
    lable.canAdd=YES;
    lable.alpha=0.0;
    [lable onlineLuckyLableColor];
    [_currentExistArray addObject:lable];
    [self.view addSubview:lable];
    [UIView animateWithDuration:0.4 animations:^{
        lable.alpha=1;
    }];

}
#pragma mark --根据lable的placeTag产生在界面中所对应的x，y。
-(NSDictionary *)caculatePosition:(NSNumber *)placeNumber
{
    
    NSInteger place = [placeNumber integerValue];
    NSInteger x=_frame.origin.x+_widthGap+(place/10-1)*(_width+_widthGap);
    NSInteger y=_frame.origin.y+_heightGap+(place%10-1)*(_height+_heightGap);
    x = x;
    y = y;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:
                         [NSNumber numberWithInteger:x],kPlaceX,
                         [NSNumber numberWithInteger:y],kPlaceY,
                         nil];
    
    return dic;
    
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
    [self.slideView addGestureRecognizer:swipe];
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    swipe.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.slideView addGestureRecognizer:swipe];
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    swipe.direction=UISwipeGestureRecognizerDirectionUp;
    [self.slideView addGestureRecognizer:swipe];
    
    swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeFrom:)];
    swipe.direction=UISwipeGestureRecognizerDirectionDown;
    [self.slideView addGestureRecognizer:swipe];
    
}
#pragma mark --每次滑动触发的方法
-(void)swipeFrom:(UISwipeGestureRecognizer *)swipe
{
    self.slideView.userInteractionEnabled = YES;
    [self resetGameState];
      // 连接好友后进行数据传输
//    if (self.blueTooth) {
////        NSData *data = [swipe.direction dataUsingEncoding:NSUTF8StringEncoding];
////        [self.blueTooth sendData:data];
//        NSLog(@"--------------------------%@",swipe.description);
//    }
////  往
//    [self.gestureArray addObject:[NSNumber numberWithInteger:swipe.direction]];
    
    
    //    self.view.userInteractionEnabled=NO;
    switch (swipe.direction) {
        case UISwipeGestureRecognizerDirectionRight:
            [self moveLabel:1];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            [self moveLabel:2];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            [self moveLabel:3];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [self moveLabel:4];
            break;
        default:
            break;
    }
    //把_currentExistArray中的数填充到_currentArray中
    [self setCurrentArray];
    //    [self lastGame];
    if (self.currentExistArray.count<16&&_canBornNewLabel) {
        
        //        判断红蓝块还有没有
        int judge = [self judgement];
        if (!swipe.view) {
            if (judge ==2) {
                NSUserDefaults *user =  [NSUserDefaults standardUserDefaults];
                NSInteger random = [[user objectForKey:@"random"] integerValue];
                NSLog(@"random1 %lu",random);
                if (random) {
                    [self bornNewLabel:random];
                }
                else{
                    random = arc4random()%(self.emptyPlaceArray.count-1);
                    [user setObject:@(random) forKey:@"random"];
                    [self bornNewLabel:random];
                }
                
                
            }
        }else{
            
            if (judge ==2) {
                NSInteger random;
                random = arc4random()%(self.emptyPlaceArray.count-1);
                NSUserDefaults *user =  [NSUserDefaults standardUserDefaults];
                [user setObject:@(random) forKey:@"random"];
                [self bornNewLabel:random];
            }
            
        }
    }
    if (self.currentExistArray.count==16)
    {
        [self isGameOver];
    }
//    NSData *teD = [NSKeyedArchiver archivedDataWithRootObject:self.currentArray];
    if (swipe.view) {
    
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSNumber *number = [user objectForKey:@"random"];
        NSLog(@"number  --%@",number);
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:number forKey:@"random"];
        [dic setObject:@(swipe.direction) forKey:@"direct"];
        NSMutableData *data = [[NSMutableData alloc]init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
        [archiver encodeObject:dic forKey:@"send data"];
        [archiver finishEncoding];
#warning yaoxie
//        NSString *dataString = [NSString stringWithFormat:@"%lu",swipe.direction];
//        NSData *teD = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        [self sendDataAction:data];
    }

   
    self.slideView.userInteractionEnabled = NO;
}
#pragma mark 判断红蓝双方的方块数是否为0
-(int)judgement
{
    int redCount = 0;
    int blueCount = 0;
    for (LuckyLabel *label in self.currentExistArray) {
        if (label.backgroundColor == [UIColor redColor]) {
            redCount++;
        }else if (label.backgroundColor == [UIColor blueColor]){
            blueCount++;
        }
    }
    if (blueCount== 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Over" message:@"红方胜" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return 1;
    }
    if (redCount== 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Over" message:@"蓝方胜" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return 1;
    }
    return 2;
}
#pragma mark --每次移动完随机产生新的lable
-(void)bornNewLabel:(NSInteger)ran
{
    [self setEmptyArray];
    NSInteger random;
    
    if (self.emptyPlaceArray.count>1) {
#warning 改动
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        NSInteger random =[[user objectForKey:@"ran"] integerValue];
//        if (random) {
//            
//        }else{
//        random = arc4random()%(self.emptyPlaceArray.count-1);
//        }
        random = ran;
    }else
    {
        random = 0;
    }
//    NSInteger random2=arc4random()%2;
    NSLog(@"ran  %lu",ran);
    [self addLuckyLabel:random WithNum:[[_labelArray objectAtIndex:0] integerValue]];
    [self setCurrentArray];
}
#pragma mark --判断游戏是否结束
#warning 这里有问题，缺条件 当红蓝块都有的情况下，要进行双方分数对比
-(void)isGameOver
{
    _isOver = YES;
    //对四个方向再移动验证一下
    for (int i=1; i<=4; i++) {
        if([self moveLabel:i]==10)
        {
            break;
        }
    }
    
    
    if (self.isOver == YES) {
        UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"Game Over" message:@"Game Over" delegate:self cancelButtonTitle:@"" otherButtonTitles:@"again", nil];
        alertView.tag=99;
        [alertView show];
    }
}
#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==99) {
        if (buttonIndex==0) {
            
        }else{
            [self setBegin];
        }
    }else if(alertView.tag==100)
    {
        
    }
}

#pragma mark --lable进行移动
-(int)moveLabel:(int) directionFlag
{
    NSMutableArray *array1=[[NSMutableArray alloc]init];
    NSMutableArray *array2=[[NSMutableArray alloc]init];
    NSMutableArray *array3=[[NSMutableArray alloc]init];
    NSMutableArray *array4=[[NSMutableArray alloc]init];
    
    switch (directionFlag) {
        case 1://right
            for (LuckyLabel *lable in _currentExistArray) {
                switch (lable.placeTag/10) {
                    case 1:
                        [array4 addObject:lable];
                        break;
                    case 2:
                        [array3 addObject:lable];
                        break;
                    case 3:
                        [array2 addObject:lable];
                        break;
                    case 4:
                        [array1 addObject:lable];
                        break;
                    default:
                        break;
                }
            }
            
            
            for (LuckyLabel *lable in array2) {
                if([self checkFrontLabel:lable andDirection:1]==10)
                {
                    return 10;
                }
            }
            for (LuckyLabel *lable in array3) {
                if([self checkFrontLabel:lable andDirection:1]==10)
                {
                    return 10;
                }
            }
            for (LuckyLabel *lable in array4) {
                if([self checkFrontLabel:lable andDirection:1]==10)
                {
                    return 10;
                }
            }
            break;
        case 2: //left
            for (LuckyLabel *label in self.currentExistArray) {
                switch (label.placeTag/10) {
                    case 1:
                        [array1 addObject:label];
                        break;
                    case 2:
                        [array2 addObject:label];
                        break;
                    case 3:
                        [array3 addObject:label];
                        break;
                    case 4:
                        [array4 addObject:label];
                        break;
                    default:
                        break;
                }
            }
            for (LuckyLabel *childLabel in array2) {
                if([self checkFrontLabel:childLabel andDirection:2]==10)
                {
                    return 10;
                }
                
            }
            for (LuckyLabel *childLabel in array3) {
                if([self checkFrontLabel:childLabel andDirection:2]==10)
                {
                    return 10;
                }
                
            }
            for (LuckyLabel *childLabel in array4) {
                if([self checkFrontLabel:childLabel andDirection:2]==10)
                {
                    return 10;
                }
                
            }
            break;
        case 3: // up
            for (LuckyLabel *label in self.currentExistArray) {
                switch (label.placeTag%10) {
                    case 1:
                        [array1 addObject:label];
                        break;
                    case 2:
                        [array2 addObject:label];
                        break;
                    case 3:
                        [array3 addObject:label];
                        break;
                    case 4:
                        [array4 addObject:label];
                        break;
                    default:
                        break;
                }
            }
            for (LuckyLabel *childLabel in array2) {
                if([self checkFrontLabel:childLabel andDirection:3]==10)
                {
                    return 10;
                }
            }
            for (LuckyLabel *childLabel in array3) {
                if([self checkFrontLabel:childLabel andDirection:3]==10)
                {
                    return 10;
                }
            }
            for (LuckyLabel *childLabel in array4) {
                if([self checkFrontLabel:childLabel andDirection:3]==10)
                {
                    return 10;
                }
            }
            break;
        case 4: // down
            for (LuckyLabel *label in self.currentExistArray) {
                switch (label.placeTag%10) {
                    case 4:
                        [array1 addObject:label];
                        break;
                    case 3:
                        [array2 addObject:label];
                        break;
                    case 2:
                        [array3 addObject:label];
                        break;
                    case 1:
                        [array4 addObject:label];
                        break;
                    default:
                        break;
                }
            }
            
            for (LuckyLabel *childLabel in array2) {
                if([self checkFrontLabel:childLabel andDirection:4]==10)
                {
                    return 10;
                }
            }
            for (LuckyLabel *childLabel in array3) {
                if([self checkFrontLabel:childLabel andDirection:4]==10)
                {
                    return 10;
                }
            }
            for (LuckyLabel *childLabel in array4) {
                if([self checkFrontLabel:childLabel andDirection:4]==10)
                {
                    return 10;
                }
            }
            break;
        default:
            break;
    }
    _core+=_coreAdd;
    [self scoreNumber];
    _coreAdd=0;
    return 30;
}
#pragma mark --移动时所调用的递归
-(int)checkFrontLabel:(LuckyLabel *)label andDirection:(int) direction
{
    switch (direction) {
//            右滑
        case 1:
            for (LuckyLabel *childLabel in _currentExistArray) {
//                NSLog(@"%lu",label.placeTag);
//                如果是左右两个label，并且label上数字相同时
                if ((label.placeTag+10==childLabel.placeTag)&&(label.numberTag==childLabel.numberTag)) {
                    if (_isOver==YES) {
                        _isOver=NO;
                        return 10;
                    }
                    if (childLabel.canAdd) {
//                        _coreAdd+=label.numberTag*2;
                        label.numberTag=label.numberTag*2;
                        [self setLabelColor:label andChildLabel:childLabel];
                        //                        [label onlineLuckyLableColor];
                        label.text=[NSString stringWithFormat:@"%ld",(long)label.numberTag];
                        label.frame=childLabel.frame;
                        label.placeTag+=10;
                        [_currentExistArray removeObject:childLabel];
                        [childLabel removeFromSuperview];
//                        可以生成新的label
                        _canBornNewLabel=YES;
                        label.canAdd=NO;
                    }
                    _isOver=NO;
                    return 20;
                }else if((label.placeTag+10==childLabel.placeTag)&&(label.numberTag!=childLabel.numberTag  )){//如果是左右两个label，并且label上的数字不同，
                    return 20;
                }
            }//for循环结束
            
            //在前面结束判断结束后，若label的位置在第三列

            if ((label.placeTag+10)/10==4) {
                label.placeTag += 10;
                CGRect frame2 = label.frame;
                frame2.origin.x += _width+_widthGap;
                label.frame = frame2;
                _canBornNewLabel=YES;
                return 20;
            }
            //不是第三列，

            else {
                label.placeTag += 10;
                CGRect frame2 = label.frame;
                frame2.origin.x += _width+_widthGap;
                label.frame = frame2;
                _canBornNewLabel=YES;
//                迭代
                [self checkFrontLabel:label andDirection:1];
              
            }
            
            
            break;
        case 2:
            for (LuckyLabel *childLabel in _currentExistArray) {
                if ((label.placeTag-10==childLabel.placeTag)&&(label.numberTag==childLabel.numberTag)) {
                    if (_isOver==YES) {
                        _isOver=NO;
                        return 10;
                    }
                    if (childLabel.canAdd) {
                        _coreAdd+=label.numberTag*2;
                        label.numberTag=label.numberTag*2;
//                        [label onlineLuckyLableColor];
                        [self setLabelColor:label andChildLabel:childLabel];
                        label.text=[NSString stringWithFormat:@"%ld",(long)label.numberTag];
                        label.frame=childLabel.frame;
                        label.placeTag-=10;
                        [_currentExistArray removeObject:childLabel];
                        [childLabel removeFromSuperview];
                        _canBornNewLabel=YES;
                        label.canAdd=NO;
                    }
                    _isOver=NO;
                    return 20;
                }else if((label.placeTag-10==childLabel.placeTag)&&(label.numberTag!=childLabel.numberTag  )){
                    return 20;
                }
            }
            if ((label.placeTag-10)/10==1) {
                label.placeTag -= 10;
                CGRect frame2 = label.frame;
                frame2.origin.x -=(_width+_widthGap);
                label.frame = frame2;
                _canBornNewLabel=YES;
                return 20;
            }
            else
            {
                label.placeTag -= 10;
                CGRect frame2 = label.frame;
                frame2.origin.x -= _width+_widthGap;
                label.frame = frame2;
                _canBornNewLabel=YES;
                //                if ([self selfStateIsValid:label andDirection:2] || [self  isFrontLabelEmpty:label andDirection:1]) {
                [self checkFrontLabel:label andDirection:2];
                //                }
            }
            break;
        case 3:
            for (LuckyLabel *childLabel in _currentExistArray) {
                if ((label.placeTag-1==childLabel.placeTag)&&(label.numberTag==childLabel.numberTag)) {
                    if (_isOver) {
                        _isOver=NO;
                        return 10;
                    }
                    if (childLabel.canAdd) {
                        _coreAdd+=label.numberTag*2;
                        label.numberTag=label.numberTag*2;
//                        [label onlineLuckyLableColor];
                        [self setLabelColor:label andChildLabel:childLabel];
                        label.text=[NSString stringWithFormat:@"%ld",(long)label.numberTag];
                        label.frame=childLabel.frame;
                        label.placeTag-=1;
                        [_currentExistArray removeObject:childLabel];
                        [childLabel removeFromSuperview];
                        _canBornNewLabel=YES;
                        label.canAdd=NO;
                    }
                    _isOver=NO;
                    return 20;
                }else if((label.placeTag-1==childLabel.placeTag)&&(label.numberTag!=childLabel.numberTag  )){
                    return 20;
                }
            }
            if ((label.placeTag-1)%10==1) {
                label.placeTag -= 1;
                CGRect frame2 = label.frame;
                frame2.origin.y -= (_height+_heightGap);
                label.frame = frame2;
                _canBornNewLabel=YES;
                return 20;
            }
            else
            {
                label.placeTag -= 1;
                CGRect frame2 = label.frame;
                frame2.origin.y -= (_height+_heightGap);
                label.frame = frame2;
                _canBornNewLabel=YES;
                //                if ([self selfStateIsValid:label andDirection:2] || [self  isFrontLabelEmpty:label andDirection:1]) {
                [self checkFrontLabel:label andDirection:3];
                //                }
            }
            break;
        case 4:
            for (LuckyLabel *childLabel in _currentExistArray) {
                if ((label.placeTag+1==childLabel.placeTag)&&(label.numberTag==childLabel.numberTag)) {
                    if (_isOver) {
                        _isOver=NO;
                        return 10;
                    }
                    if (childLabel.canAdd) {
                        _coreAdd+=label.numberTag*2;
                        label.numberTag=label.numberTag*2;
//                        [label onlineLuckyLableColor];
                        [self setLabelColor:label andChildLabel:childLabel];
                        label.text=[NSString stringWithFormat:@"%ld",(long)label.numberTag];
                        label.frame=childLabel.frame;
                        label.placeTag+=1;
                        [_currentExistArray removeObject:childLabel];
                        [childLabel removeFromSuperview];
                        _canBornNewLabel=YES;
                        label.canAdd=NO;
                    }
                    _isOver=NO;
                    return 20;
                }else if((label.placeTag+1==childLabel.placeTag)&&(label.numberTag!=childLabel.numberTag  )){
                    return 20;
                }
            }
            if ((label.placeTag+1)%10==4) {
                label.placeTag += 1;
                CGRect frame2 = label.frame;
                frame2.origin.y += (_height+_heightGap);
                label.frame = frame2;
                _canBornNewLabel=YES;
                return 20;
            }
            else
            {
                label.placeTag += 1;
                CGRect frame2 = label.frame;
                frame2.origin.y += (_height+_heightGap);
                label.frame = frame2;
                _canBornNewLabel=YES;
                //                if ([self selfStateIsValid:label andDirection:2] || [self  isFrontLabelEmpty:label andDirection:1]) {
                [self checkFrontLabel:label andDirection:4];
                //                }
            }
            break;
            
        default:
            break;
    }
    return 30;
}
#pragma mark 设置合并后label的背景颜色
-(void)setLabelColor:(LuckyLabel *)label andChildLabel:(LuckyLabel *)childLabel
{
    UIColor *color = label.backgroundColor;
    if ((label.backgroundColor == [UIColor whiteColor]) || (childLabel.backgroundColor  == [UIColor whiteColor])) {
        if (label.backgroundColor == [UIColor blueColor]) {
            
            label.backgroundColor = [UIColor blueColor];
            
        }else if (label.backgroundColor == [UIColor redColor])
        {
            label.backgroundColor = [UIColor redColor];
            
        }else if (childLabel.backgroundColor == [UIColor redColor])
        {
            label.backgroundColor = [UIColor redColor];
            
        }else if (childLabel.backgroundColor == [UIColor blueColor])
        {
            label.backgroundColor = [UIColor blueColor];
        }
        
    }else if ((label.backgroundColor == [UIColor blueColor]) || (label.backgroundColor  == [UIColor redColor])){
        if (childLabel.backgroundColor == [UIColor blueColor] || (childLabel.backgroundColor  == [UIColor redColor])) {
            label.backgroundColor = color;
        }
    }

}
//#pragma mark --重新开始游戏
//-(void)againGame
//{
//    for (LuckyLabel *lable in _currentExistArray) {
//        [lable removeFromSuperview];
//    }
//    [self deleteLastGame];
//    [_currentArray removeAllObjects];
//
//}
#pragma mark -- 清空NSUserDefaults中上次的记录
-(void)deleteLastGame
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"currentDic"];
    
    [defaults synchronize];
}

- (IBAction)onlineConnect:(UIButton *)sender {
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:2345 error:&error];
    if (result) {
        
        [self againGame];
        self.slideView.userInteractionEnabled = NO;
        NSLog(@"%@",[@"" stringByAppendingString:@"\n监听成功"]);
    } else {
           NSLog(@"%@ %@",@"监听失败",error);
        
    }

}
#pragma mark 发送数据
-(void)sendDataAction:(NSData *)data
{
    if (data) {
        
        [self.clientSocket writeData:data withTimeout:-1 tag:0];

    }
}
#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
     self.slideView.userInteractionEnabled = YES;
     self.clientSocket = newSocket;
    
    [self.clientSocket readDataWithTimeout:-1 tag:0];
    
    NSLog(@"成功连接");
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (data) {
//        [self deleteLastGame];
//        [self.currentArray removeAllObjects];
//       
//        NSMutableArray *dataArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//        NSLog(@"%@",dataArray);
//        self.currentArray = dataArray;
//        [self startGameWithLastMessage];
        
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        NSDictionary *dic = [unarchiver decodeObjectForKey:@"send data"];
        [unarchiver finishDecoding];
        NSNumber *direct = [dic objectForKey:@"direct"];
        NSInteger random = [[dic objectForKey:@"random"] integerValue];
        NSLog(@"shoudaode %lu",random);
        NSUserDefaults *user= [NSUserDefaults standardUserDefaults];
        [user setObject:@(random) forKey:@"random"];
        
        
//        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"dataString -------%@",dataString);
//        NSLog(@"swipe  %@",(UISwipeGestureRecognizer *)[NSNumber numberWithInt:1]);
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]init];
        if ([direct intValue] == 1) {
            
            swipe.direction = UISwipeGestureRecognizerDirectionRight;
            
        }else if ([direct integerValue]==2 ){
            swipe.direction = UISwipeGestureRecognizerDirectionLeft;
            
            
        }else if ([direct integerValue]==8 ){
            swipe.direction = UISwipeGestureRecognizerDirectionDown;
            
            
        }else if ([direct integerValue]==4){
            swipe.direction = UISwipeGestureRecognizerDirectionUp;
            
            
        }
        [self swipeFrom:swipe];
        self.slideView.userInteractionEnabled = YES;

        NSLog(@"成功接收数据");
//        tag是标识，保证读与写的tag相同，才可以让回调的地方有回复
//        －1表示没有设置超时，因为默认超时，会断开连接
        [self.clientSocket readDataWithTimeout:-1 tag:0];
           }
   
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"消息发送成功");
    self.slideView.userInteractionEnabled = NO;
}
- (IBAction)musicSwitch:(UISwitch *)sender {
    
    if (sender.isOn) {
        [XMGAudioTool playMusicWithMusicName:@"This Kiss.mp3"];
        
    }else{
        [XMGAudioTool stopMusicWithMusicName:@"This Kiss.mp3"];
    }
}

@end

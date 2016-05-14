//
//  SingleViewController.m
//  Online2048
//
//  Created by DMY on 16/4/30.
//  Copyright © 2016年 DMY. All rights reserved.
//


#import "SingleViewController.h"
#import "LuckyLabel.h"
#import "SetView.h"
#import "HelpView.h"

@interface SingleViewController ()<UIAlertViewDelegate>
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


@end

@implementation SingleViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGesture];
  
   
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self againGame];
}
#pragma mark --重新开始游戏时的初始化
-(void)initData
{
    //第一个小的uiView的frame
    _frame=[self.view viewWithTag:100].frame;
    //背景uiview的frame
    CGRect fra=[self.view viewWithTag:101].frame;
    NSLog(@"-----------------%@",NSStringFromCGRect(fra));
    _width=fra.size.width;
    _height=fra.size.height;
    _widthGap=fra.origin.x;
    _heightGap=fra.origin.y;
    _core=0;
    _coreAdd=0;
    [self scoreNumber];
    _stepArray=[[NSMutableArray alloc]init];
    _labelArray = [NSArray arrayWithObjects:
                   [NSNumber numberWithInteger:2],
                   [NSNumber numberWithInteger:4],
                   nil];
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
        //        NSLog(@"test3%@",_currentArray);
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
    //    [_stepArray addObject:[_currentArray copy]];
    [self resetGameState];
}

#pragma mark --把_currentExistArray中的数填充到_currentArray中
-(void)setCurrentArray
{

    [_currentArray removeAllObjects];
    for (LuckyLabel *lable in _currentExistArray) {
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:lable.placeTag],@"placeTag",[NSNumber numberWithInteger:lable.numberTag],@"numberTag", nil];
        [_currentArray addObject:dic];
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_currentArray,@"currentArray",_score.text,@"core", nil];
    [defaults setObject:dic forKey:@"currentDic"];
    //    NSLog(@"test:%@",_currentArray);
    //    NSLog(@"test2:%@",[defaults objectForKey:@"currentArray"]);
    [defaults synchronize];
}

#pragma mark --依据_currentArray 填充游戏界面 及同步emptyArray与currentExistArray
-(void)startGameWithLastMessage
{
    for (NSDictionary *dic in _currentArray) {
        //        NSLog(@"%@",dic);
        NSInteger random=[_emptyPlaceArray indexOfObject:[dic objectForKey:@"placeTag"]];
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


#pragma mark --重新开始游戏时需要添加的两个lable
-(void)firstBornLabel
{
    NSInteger k = 0;//记录第一次产生的数据
    for (NSInteger i=0; i<2; i++) {
        NSInteger random;
        random=arc4random()%(self.emptyPlaceArray.count-1);
        if (i==0) {
            k=random;
        }else {//防止第一次和第二次重合了
            while (k==random) {
                random=arc4random()%(self.emptyPlaceArray.count-1);
            }
        }
        NSInteger random2=arc4random()%2;
        [self addLuckyLabel:random WithNum:[[_labelArray objectAtIndex:random2] integerValue]];
        [self setCurrentArray];
    }
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

#pragma mark --通过位置数字和值产生lable 同步_currentExistArray
-(void)addLuckyLabel:(NSInteger)random WithNum:(NSInteger)num
{
    LuckyLabel *lable=[[LuckyLabel alloc]init];
    NSNumber *place=[self.emptyPlaceArray objectAtIndex:random];
    lable.placeTag=[place intValue];
    
    NSDictionary *dic=[self caculatePosition:place];
    lable.frame=CGRectMake([[dic objectForKey:kPlaceX] intValue], [[dic objectForKey:kPlaceY] intValue], _width, _height);
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
#pragma mark -- 记录所获得的分数
-(void)scoreNumber
{
    _score.text=[NSString stringWithFormat:@"%ld",_core];
    //判断此时是否超过最高分
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"heightScore"]) {
        NSNumber *number=[defaults objectForKey:@"heightScore"];
        if ([number longValue]>_core) {
            _hightScore.text=[NSString stringWithFormat:@"%@",number];
        }else{
            [defaults setObject:[NSNumber numberWithLong:_core] forKey:@"heightScore"];
            _hightScore.text=[NSString stringWithFormat:@"%ld",_core];
            [defaults synchronize];
        }
    }else{
        [defaults setObject:[NSNumber numberWithLong:0] forKey:@"heightScore"];
        [defaults synchronize];
        _hightScore.text=@"0";
    }
}
#pragma mark -- 在NSUserDefaults中记录下当前数据，以便下次进入游戏继续完
-(void)lastGame
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_currentArray,@"currentArray",_score.text,@"core", nil];
    [defaults setObject:dic forKey:@"currentDic"];
    //    NSLog(@"%@",_currentArray);
    [defaults synchronize];
}
#pragma mark -- 清空NSUserDefaults中上次的记录
-(void)deleteLastGame
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"currentDic"];
    [defaults synchronize];
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
    [self resetGameState];
    //在滑动之前把当前步骤记下来
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[_currentArray copy],@"currentArray" ,_hightScore.text,@"hightScore",_score.text,@"score",nil];
    [_stepArray addObject:dic];
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
        [self bornNewLabel];
    }
    if (self.currentExistArray.count==16)
    {
        [self isGameOver];
    }
}

#pragma mark --判断游戏是否结束
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
        UIAlertView *alertView =  [[UIAlertView alloc]initWithTitle:@"Game Over" message:@"Game Over" delegate:self cancelButtonTitle:@"return" otherButtonTitles:@"again", nil];
        alertView.tag=99;
        [alertView show];
    }
}
#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==99) {
        if (buttonIndex==0) {
            [self returnStep];
        }else{
            [self againGame];
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
        case 1:
            for (LuckyLabel *childLabel in _currentExistArray) {
                if ((label.placeTag+10==childLabel.placeTag)&&(label.numberTag==childLabel.numberTag)) {
                    if (_isOver==YES) {
                        _isOver=NO;
                        return 10;
                    }
                    if (childLabel.canAdd) {
                        _coreAdd+=label.numberTag*2;
                        label.numberTag=label.numberTag*2;
                        [label luckyLableColor];
                        label.text=[NSString stringWithFormat:@"%ld",(long)label.numberTag];
                        label.frame=childLabel.frame;
                        label.placeTag+=10;
                        [_currentExistArray removeObject:childLabel];
                        [childLabel removeFromSuperview];
                        _canBornNewLabel=YES;
                        label.canAdd=NO;
                    }
                    _isOver=NO;
                    return 20;
                }else if((label.placeTag+10==childLabel.placeTag)&&(label.numberTag!=childLabel.numberTag  )){
                    return 20;
                }
            }
            if ((label.placeTag+10)/10==4) {
                label.placeTag += 10;
                CGRect frame2 = label.frame;
                frame2.origin.x += _width+_widthGap;
                label.frame = frame2;
                _canBornNewLabel=YES;
                return 20;
            }
            else
            {
                label.placeTag += 10;
                CGRect frame2 = label.frame;
                frame2.origin.x += _width+_widthGap;
                label.frame = frame2;
                _canBornNewLabel=YES;
                //                if ([self selfStateIsValid:label andDirection:2] || [self  isFrontLabelEmpty:label andDirection:1]) {
                [self checkFrontLabel:label andDirection:1];
                //                }
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
                        [label luckyLableColor];
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
                        [label luckyLableColor];
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
                        [label luckyLableColor];
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
#pragma mark --每次移动完随机产生新的lable
-(void)bornNewLabel
{
    [self setEmptyArray];
    int random;
    
    if (self.emptyPlaceArray.count>1) {
        random = arc4random()%(self.emptyPlaceArray.count-1);
    }else
    {
        random = 0;
    }
    NSInteger random2=arc4random()%2;
    
    [self addLuckyLabel:random WithNum:[[_labelArray objectAtIndex:random2] integerValue]];
    [self setCurrentArray];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --设置按钮
- (IBAction)setting:(UIButton *)sender {
    
    SetView *set=[[NSBundle mainBundle]loadNibNamed:@"SetView" owner:self options:nil].lastObject;
    set.frame = self.view.bounds;

   set.block1=^{
        [self againGame];
    };
    set.block2=^{
        HelpView *help=[[NSBundle mainBundle]loadNibNamed:@"HelpView" owner:self options:nil].lastObject;
        help.frame = self.view.bounds;
        [self.view addSubview:help];
        [self.view bringSubviewToFront:help];
    };
    
    [self.view addSubview:set];
}


#pragma mark --重新开始游戏
-(void)againGame
{
    for (LuckyLabel *lable in _currentExistArray) {
        [lable removeFromSuperview];
    }
    [self deleteLastGame];
    [_stepArray removeAllObjects];
    [_currentArray removeAllObjects];
    [self initData];
}
#pragma mark --返回上一步
- (IBAction)share:(UIButton *)sender {
    [self returnStep];
}

-(void)returnStep
{
    
    if (_stepArray.count>0) {
        for (LuckyLabel *lable in _currentExistArray) {
            [lable removeFromSuperview];
        }
        [_currentExistArray removeAllObjects];
        [self setEmptyArray];
#warning 需要注意，以防在内存中出现错误
        //注意这儿要用深mutableCopy，不然_currentArray指向的是不可变数组（NSArray）的内存空间，当后面调用NSMutableArray 中的removeAllObject 会蹦
        NSDictionary *dic=[_stepArray objectAtIndex:_stepArray.count-1];
        _currentArray=[[dic objectForKey:@"currentArray"] mutableCopy];
        _core=[[dic objectForKey:@"score"] integerValue];
        _score.text=[dic objectForKey:@"score"];
        _hightScore.text=[dic objectForKey:@"hightScore"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:[_hightScore.text integerValue]] forKey:@"heightScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [_stepArray removeLastObject];
        //        NSLog(@"_currentArray:%@",_currentArray);
        //        NSLog(@"_stepArray:%@",_stepArray);
        [self startGameWithLastMessage];
        [self resetGameState];
        
        [self lastGame];
        
    }else
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"不能再返回了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag=100;
        [alertView show];
    }
    //    NSLog(@"_currentExistArray:%@",_currentExistArray);
    //    NSLog(@"_currentArray:%@",_currentArray);
    //    NSLog(@"_emptyPlaceArray:%@",_emptyPlaceArray);
}


@end


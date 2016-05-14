//
//  OnlineViewController.h
//  Online2048
//
//  Created by DMY on 16/5/5.
//  Copyright © 2016年 DMY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnlineViewController : UIViewController



@property(nonatomic,strong)NSMutableArray *currentExistArray;//里面每个元素是一个lable
@property (nonatomic,strong) NSMutableArray *currentArray;//里面每个元素是一个字典，记录lable的值与位置
@property (nonatomic,strong) NSMutableArray *gestureArray;//里面记录每一局的玩家的手势
@property(nonatomic,strong)NSMutableArray *emptyPlaceArray;//里面每个元素是空着的位置，是个数字
@property(nonatomic,strong)NSArray *labelArray; //里面存放随机产生label上的数字

@property(nonatomic)BOOL canBornNewLabel;
@property(nonatomic)BOOL isOver;





@property (weak, nonatomic) IBOutlet UILabel *myScore;
@property (weak, nonatomic) IBOutlet UILabel *competitorScore;

@end

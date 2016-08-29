//
//  SingleViewController.h
//  Online2048
//
//  Created by DMY on 16/4/30.
//  Copyright © 2016年 DMY. All rights reserved.
//


#import <UIKit/UIKit.h>

#define kPlaceX @"X"
#define kPlaceY @"Y"

@interface SingleViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *currentExistArray;//里面每个元素是一个lable
@property (nonatomic,strong) NSMutableArray *currentArray;//里面每个元素是一个字典，记录lable的值与位置
@property (nonatomic,strong) NSMutableArray *stepArray;//里面记录每一局的步骤
@property(nonatomic,strong)NSMutableArray *emptyPlaceArray;//里面每个元素是空着的位置，是个数字
@property(nonatomic,strong)NSArray *labelArray;

@property(nonatomic)BOOL canBornNewLabel;
@property(nonatomic)BOOL isOver;



@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *hightScore;

- (IBAction)setting:(UIButton *)sender;

- (IBAction)share:(UIButton *)sender;

-(void)againGame;

@end

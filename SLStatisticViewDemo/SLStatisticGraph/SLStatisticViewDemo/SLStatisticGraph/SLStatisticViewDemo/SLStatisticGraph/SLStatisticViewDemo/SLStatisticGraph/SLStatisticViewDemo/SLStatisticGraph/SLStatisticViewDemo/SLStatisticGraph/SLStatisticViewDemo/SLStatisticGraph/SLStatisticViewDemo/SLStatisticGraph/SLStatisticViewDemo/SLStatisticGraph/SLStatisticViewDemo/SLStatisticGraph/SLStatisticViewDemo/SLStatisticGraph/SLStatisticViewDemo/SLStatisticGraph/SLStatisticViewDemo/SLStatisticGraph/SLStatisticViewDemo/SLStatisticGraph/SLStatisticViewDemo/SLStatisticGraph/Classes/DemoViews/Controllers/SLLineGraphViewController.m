//
//  SLLineGraphViewController.m
//  SLStatisticGraph
//
//  Created by smart on 16/4/26.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "SLLineGraphViewController.h"
#import "CSLStatisticLib.h"

@interface SLLineGraphViewController ()
@property (nonatomic, weak) LineChartView* chat;
@property (nonatomic, strong) statisticsSet* newset;

@property (nonatomic, strong) NSMutableArray* xarray;
@property (nonatomic, strong) NSMutableArray* yarray;

@property (nonatomic, strong) NSMutableArray* xarray0;
@property (nonatomic, strong) NSMutableArray* yarray0;


- (IBAction)showRandomArray1:(UIButton *)sender;
- (IBAction)showRandomArray2:(UIButton *)sender;
- (IBAction)animateClick:(UIButton *)sender;
- (IBAction)sharpChange:(UIButton *)sender;
@end

@implementation SLLineGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    statisticsSet* newset = [[statisticsSet alloc]init];
    self.newset = newset;
    newset.ytotal = 100;
    newset.ybasic = 0;
    newset.yunit = 5;
    newset.xunit = 1;
    newset.typicalXlabel = @"10:00";
    newset.typicalYlabel = @"100";
    newset.yaxisTop = 20;
    newset.yaxisbottom = 35;
    newset.xaxisbottom = 20;
    newset.myW = 200;
    newset.myH = 400;
    
    newset.CurveColor = [UIColor redColor];
    newset.PointColor = [UIColor blackColor];
    newset.XlabelColor = [UIColor redColor];
    newset.ylineCorlor = SLColor(0x00, 0x00, 0x00, 0.7);
    newset.ReminderColor = [UIColor blueColor];
    
    newset.animate = NO;
    newset.cureved = NO;
    
    CGRect rect = CGRectMake(0, 100, 320, 468);
    LineChartView* chat = [LineChartView builtNewstatisticViewWithFrame:rect statisticset:newset];
    self.chat = chat;
    self.chat.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:chat];
}

#pragma mark - 懒加载和假数据
-(NSMutableArray *)xarray{
    if (_xarray == nil) {
        _xarray = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            NSString* string = [NSString stringWithFormat:@"%d:00", i+1];
            [_xarray addObject:string];
        }
    }
    return _xarray;
}

-(NSMutableArray *)yarray{
    if (_yarray == nil) {
        _yarray = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            int y = arc4random() % 100 + 1;
            if ((i == 2) || (i == 3)) {
                y = 255;
            }
            NSNumber* num = [NSNumber numberWithInt:y];
            [_yarray addObject:num];
        }
    }
    return _yarray;
}

-(NSMutableArray *)xarray0{
    if (_xarray0 == nil) {
        _xarray0 = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            NSString* string = [NSString stringWithFormat:@"%d Friend", i+1];
            [_xarray0 addObject:string];
        }
    }
    return _xarray0;
}

-(NSMutableArray *)yarray0{
    if (_yarray0 == nil) {
        _yarray0 = [NSMutableArray array];
        for (int i = 0; i < 30; i++) {
            int y = arc4random() % 100 + 1;
            NSNumber* num = [NSNumber numberWithInt:y];
            [_yarray0 addObject:num];
        }
    }
    return _yarray0;
}

#pragma mark - 按键处理
- (IBAction)showRandomArray1:(UIButton *)sender {
    self.newset.typicalXlabel = @"12:00";
    [self.chat setLinechatset:self.newset];
    [self.chat setDataXarray:self.xarray Yarray:self.yarray];
}

- (IBAction)showRandomArray2:(UIButton *)sender{
    self.newset.typicalXlabel = @"12 Friend";
    [self.chat setLinechatset:self.newset];
    [self.chat setDataXarray:self.xarray0 Yarray:self.yarray0];
}

- (IBAction)animateClick:(UIButton *)sender {
    [self.chat animate];
}

- (IBAction)sharpChange:(UIButton *)sender {
    sender.selected = ! sender.selected;
    if (sender.selected) {
        self.newset.cureved = YES;
        [self.chat setLinechatset:self.newset];
    }else{
        self.newset.cureved = NO;
        [self.chat setLinechatset:self.newset];
    }
}
@end

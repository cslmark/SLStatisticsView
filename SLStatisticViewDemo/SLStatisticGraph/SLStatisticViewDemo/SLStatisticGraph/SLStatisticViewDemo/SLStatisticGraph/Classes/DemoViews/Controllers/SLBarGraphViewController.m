//
//  SLBarGraphViewController.m
//  SLStatisticGraph
//
//  Created by smart on 16/4/26.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "SLBarGraphViewController.h"
#import "CSLStatisticLib.h"

@interface SLBarGraphViewController ()
@property (nonatomic, strong) statisticsSet* newset;
@property (nonatomic, weak) ColumnChartView* colchat;

@property (nonatomic, strong) NSMutableArray* xarray;
@property (nonatomic, strong) NSMutableArray* yarray;

@property (nonatomic, strong) NSMutableArray* xarray0;
@property (nonatomic, strong) NSMutableArray* yarray0;


- (IBAction)random1show:(UIButton *)sender;
- (IBAction)random2show:(UIButton *)sender;
- (IBAction)barAnimateshow:(UIButton *)sender;
@end

@implementation SLBarGraphViewController

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
    
    newset.CurveColor = [UIColor greenColor];
    newset.PointColor = [UIColor whiteColor];
    newset.XlabelColor = [UIColor redColor];
    newset.ylineCorlor = SLColor(0xaa, 0xaa, 0xaa, 0.7);
    newset.ReminderColor = [UIColor whiteColor];
    
    CGRect rect = CGRectMake(0, 100, 320, 468);
    ColumnChartView* colchat = [ColumnChartView builtNewstatisticViewWithFrame:rect statisticset:newset];
    self.colchat = colchat;
    self.colchat.backgroundColor = [UIColor blueColor];
    [self.view addSubview:colchat];
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

- (IBAction)random1show:(UIButton *)sender {
   self.newset.typicalXlabel = @"12:00";
   [self.colchat setLinechatset:self.newset];
   [self.colchat setDataXarray:self.xarray Yarray:self.yarray];
}

- (IBAction)random2show:(UIButton *)sender {
   self.newset.typicalXlabel = @"12 Friend";
   [self.colchat setLinechatset:self.newset];
   [self.colchat setDataXarray:self.xarray0 Yarray:self.yarray0];
}

- (IBAction)barAnimateshow:(UIButton *)sender {
   [self.colchat animate];
}




@end

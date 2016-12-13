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
{
    CGFloat itemW;
    CGFloat itemH;
    CGFloat bottomRemain;   //底部留给x坐标的范围
    CGFloat ytopRemain;
    CGFloat GraphH;
}
@property (nonatomic, strong) statisticsSet* newset;
@property (nonatomic, weak) SLColumnChartView* columnchat;

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
    
    bottomRemain = 35.0;
    ytopRemain = 20.0;
    GraphH = KScreen_H - 160;
    statisticsSet* newset = [[statisticsSet alloc]init];
    self.newset = newset;
    newset.ytotal = 160;
    newset.ybasic = -20;
    newset.yunit = 20;
    newset.xunit = 1;
    newset.typicalXlabel = @"10:00";
    newset.typicalYlabel = @"-100";
    newset.yaxisTop = ytopRemain;
    newset.yaxisbottom = bottomRemain;
    newset.xaxisbottom = 29;
    newset.myW = 345;
    newset.myH = 200;
    
    newset.CurveColor = [UIColor whiteColor];
    newset.PointColor = [UIColor colorWithHex:@"#FFCD00"];
    newset.XlabelColor = [UIColor whiteColor];
    newset.ylineCorlor = [UIColor clearColor];
    newset.ReminderColor = [UIColor colorWithHex:@"#39D02D"];
    newset.YlabelFont = [UIFont  systemFontOfSize:14.0];
    newset.YlabelColor = [UIColor whiteColor];
    
    newset.animate = NO;
    newset.cureved = YES;
    
    CGRect rect = CGRectMake(0, 160, KScreen_W, GraphH);
    SLColumnChartView* chat = [SLColumnChartView builtNewstatisticViewWithFrame:rect statisticset:newset];
    self.columnchat = chat;
    self.columnchat.backgroundColor = [UIColor clearColor];
    [self.view addSubview:chat];
    
    self.newset.typicalXlabel = @"12:00";
    [self.columnchat setColumnchatset:self.newset];
    [self.columnchat setDataXarray:self.xarray Yarray:self.yarray];
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
            int y = arc4random() % 100 -20;
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
            int y = arc4random() % 100 - 20;
            NSNumber* num = [NSNumber numberWithInt:y];
            [_yarray0 addObject:num];
        }
    }
    return _yarray0;
}

- (IBAction)random1show:(UIButton *)sender {
   self.newset.typicalXlabel = @"12:00";
   [self.columnchat setColumnchatset:self.newset];
   [self.columnchat setDataXarray:self.xarray Yarray:self.yarray];
}

- (IBAction)random2show:(UIButton *)sender {
   self.newset.typicalXlabel = @"12 Friend";
   [self.columnchat setColumnchatset:self.newset];
   [self.columnchat setDataXarray:self.xarray0 Yarray:self.yarray0];
}

- (IBAction)barAnimateshow:(UIButton *)sender {
   [self.columnchat animate];
}




@end

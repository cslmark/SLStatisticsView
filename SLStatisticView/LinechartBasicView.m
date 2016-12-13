//
//  LinechartBasicView.m
//  IOS统计图标
//
//  Created by smart on 16/1/5.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "LinechartBasicView.h"
#import "statisticsSet.h"
#import "UIBezierPath+curved.h"
#import "UIView+Frame.h"

/*****************门限制定*********************/
#define     MAXSTEP             320
#define     MINSTEP             1

@interface LinechartBasicView()
{
    //死量
    float xleft;
    float xstep;
    
    //View的宽度
    CGFloat myW;
    CGFloat myH;
    
    //提示点的位置
    int index;
    
    //用于存储pinch手势的坐标
    CGPoint point;
    float pointR;           //小圆点的半径
    
    //为了方便书写引入
    float ytop;
    float xlabelbottom;
    float ybottom;
    float xlabelminstep;
    
    BOOL curved;          //新增属性，是否曲线化
    //用来添加按钮用于点击
    NSMutableArray* buttons;
}

//增加曲线的图层
@property (nonatomic, strong)  CAShapeLayer* curveshapeLayer;
@property (nonatomic, weak) UIButton* remainbtn;
@property (nonatomic, weak) UIView* showdowView;
@property (nonatomic, weak) UIButton* indexPointButton;
@property (nonatomic, weak) UILabel* indexView;
@property (nonatomic, weak) CAShapeLayer* Zeroline;
@end

@implementation LinechartBasicView
//初始化
#pragma mark - 初始化
/**
 *  提供一个对外建立视图的方法
 */
+(LinechartBasicView*)buitStatisticsWithstatisticsSet:(statisticsSet*) linechatset{
    LinechartBasicView* view = [[LinechartBasicView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    view.linechatset = linechatset;
    [view setup];
    return view;
}

//用于添加手势
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createPinchGesture];
    }
    return  self;
}

//<默认初始化的部分>
-(void) setup{
    self.curveshapeLayer = [[CAShapeLayer alloc] init];
    self.curveshapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.curveshapeLayer];
    self.curveshapeLayer.lineJoin = @"round";
    
    
    xleft = 20;
    pointR = 4;
    //设置默认的偏移量
    if (self.linechatset.yaxisTop == 0) {
        self.linechatset.yaxisTop = 20;
    }
    if (self.linechatset.yaxisbottom == 0) {
        self.linechatset.yaxisbottom = 35;
    }
    if (self.linechatset.xaxisbottom == 0) {
        self.linechatset.xaxisbottom = 20;
    }
    //默认的字体和主题设置
    if (self.linechatset.XlabelFont == nil) {
        self.linechatset.XlabelFont = [UIFont systemFontOfSize:11];
    }
    if (self.linechatset.ReminderFont == nil) {
        self.linechatset.ReminderFont = [UIFont systemFontOfSize:15];
    }
    if (self.linechatset.XlabelColor == nil) {
        self.linechatset.XlabelColor = [UIColor whiteColor];
    }
    if (self.linechatset.ylineCorlor == nil) {
        self.linechatset.ylineCorlor = [UIColor whiteColor];
    }
    if (self.linechatset.CurveColor == nil) {
        self.linechatset.CurveColor = [UIColor whiteColor];
    }
    if (self.linechatset.PointColor == nil) {
        self.linechatset.PointColor = [UIColor whiteColor];
    }
    if (self.linechatset.ReminderColor == nil) {
        self.linechatset.ReminderColor = [UIColor whiteColor];
    }
    
    //默认的单位
    if (self.linechatset.yunit == 0) {
        self.linechatset.yunit = 1;
    }
    
    if (self.linechatset.myH != 0) {
        myH = self.linechatset.myH;
    }
    if (self.linechatset.myW != 0) {
        myW = self.linechatset.myW;
    }
    
    curved = self.linechatset.cureved;
    
    index = 0;
    NSMutableDictionary* att = [self getAttributesWithfont:self.linechatset.XlabelFont Color:self.linechatset.XlabelColor];
    CGSize size = [self.linechatset.typicalXlabel sizeWithAttributes:att];
    self.linechatset.xaxisminstep = size.width + 5;
    xstep = self.linechatset.xaxisminstep;    //默认的xstep
    ytop  = self.linechatset.yaxisTop;
    ybottom = self.linechatset.yaxisbottom;
    xlabelbottom = self.linechatset.xaxisbottom;
    xlabelminstep = self.linechatset.xaxisminstep;
}

#pragma mark - 重写set方法
-(void) setLinechatset:(statisticsSet *)linechatset{
    _linechatset = linechatset;
    //更新私有变量的数据
    NSMutableDictionary* att = [self getAttributesWithfont:self.linechatset.XlabelFont Color:self.linechatset.XlabelColor];
    CGSize size = [self.linechatset.typicalXlabel sizeWithAttributes:att];
    self.linechatset.xaxisminstep = size.width + 5;
    xstep = self.linechatset.xaxisminstep;    //默认的xstep
    ytop  = self.linechatset.yaxisTop;
    ybottom = self.linechatset.yaxisbottom;
    xlabelbottom = self.linechatset.xaxisbottom;
    xlabelminstep = self.linechatset.xaxisminstep;
    curved = self.linechatset.cureved;
    
    [self setNeedsDisplay];
}

#pragma mark - 作图部分
- (void)drawRect:(CGRect)rect {
    //保存宽高
    myW = rect.size.width;
    myH = rect.size.height;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    //开始画坐标轴X
    int xjump = 1;
    //如果很密
    if (xstep < xlabelminstep) {
        xjump = (int)(xlabelminstep / xstep) + 1;
    }
    NSDictionary *attrs = [self getAttributesWithfont:self.linechatset.XlabelFont Color:self.linechatset.XlabelColor];
    for (int i = 0; i < self.xarray.count; i+= xjump) {
        NSString *string = [NSString stringWithFormat:@"%@",self.xarray[i]];
        CGSize size = [string sizeWithAttributes:attrs];
        CGPoint localpoint = CGPointMake(xleft + i*xstep - size.width/2, myH - xlabelbottom);
        [string drawAtPoint:localpoint withAttributes:attrs];
    }

    //开始画坐标线
    [self.linechatset.ylineCorlor set];
    CGContextSetLineWidth(ctx, 0.5);
    int ycount = (self.linechatset.ytotal - self.linechatset.ybasic)/self.linechatset.yunit;
    CGFloat Ypixall = (myH - ybottom - ytop);
    CGFloat Y_padding = Ypixall / ycount;
    for (int i = 0; i < ycount+1; i++) {
        CGContextMoveToPoint(ctx, 0, (myH - (ybottom + i*Y_padding)));
        CGContextAddLineToPoint(ctx, myW, (myH - (ybottom + i*Y_padding)));
        CGContextStrokePath(ctx);
    }
    
    //放置0的线的位置 y = 0的虚线
    if ((self.linechatset.ybasic < 0) && (self.linechatset.ytotal > 0)) {
        [self.Zeroline removeFromSuperlayer];
        CGFloat ypixunit = (myH - ybottom - ytop) / (self.linechatset.ytotal - self.linechatset.ybasic);
        CGFloat yZero =  myH - (ybottom + (0 - self.linechatset.ybasic) * ypixunit);
        UIBezierPath* path = [[UIBezierPath alloc] init];
        [path moveToPoint:CGPointMake(0, yZero)];
        [path addLineToPoint:CGPointMake(myW, yZero)];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:self.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        [shapeLayer setStrokeColor:[UIColor blueColor].CGColor];
        [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],
                                        [NSNumber numberWithInt:1],nil]];
        [shapeLayer setPath:path.CGPath];
        [self.layer addSublayer:shapeLayer];
        self.Zeroline = shapeLayer;
    }

    //开始绘制曲线
    CGFloat lastX = 0, lastY = 0;
    BOOL lastCur = NO;
    CGFloat ypixunit = (myH - ybottom - ytop) / (self.linechatset.ytotal - self.linechatset.ybasic);
    
//    CGContextSaveGState(ctx);
//    [self.linechatset.CurveColor set];
//    CGContextSetLineWidth(ctx, 2.5f);
//    for (int z = 0; z < self.xarray.count; z++) {
//        NSNumber *num = self.yarray[z];
//        CGFloat ypoint0 =  myH - (ybottom + ([num intValue] - self.linechatset.ybasic) * ypixunit);
//        if ([num isEqualToNumber:NAValidNum]) {
//            ypoint0 = myH - (ybottom + (0 - self.linechatset.ybasic) * ypixunit);
//        }
//        CGFloat pointX = xleft + z*xstep;
//        CGFloat pointY = ypoint0;
//        
//        if ([num isEqualToNumber:NAValidNum]) {
//            //虚线和实线的实现
//            if (lastCur == NO) {
//                CGContextSaveGState(ctx);
//                CGFloat pattern[2] = {3,3};
//                CGContextSetLineDash(ctx, 3, pattern, 2);
//                lastCur = YES;
//            }
//        }else{
//            //虚线和实线的实现
//            if (lastCur == YES) {
//                CGContextRestoreGState(ctx);
//                lastCur = NO;
//            }
//        }
//        
//        if(z == 0)
//        {
//            CGContextMoveToPoint(ctx, pointX, pointY);
//        }else{
//            CGContextMoveToPoint(ctx, lastX, lastY);
//            //绘制曲线
//            CGFloat X2 = (lastX+pointX)/2.0;
//            CGFloat Y2 = lastY;
//            
//            CGFloat X3 = (lastX+pointX)/2.0;
//            CGFloat Y3 = pointY;
//            CGContextAddCurveToPoint(ctx, X2, Y2, X3, Y3, pointX, pointY);
//            CGContextStrokePath(ctx);
//        }
//        
//        lastX = pointX;
//        lastY = pointY;
//        
//        //        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//        //        button.layer.cornerRadius=3;
//        //        button.frame=CGRectMake(0, 0, 6, 6);
//        //        button.center = temppoint;
//        //        button.tag = z;
//        //        button.backgroundColor = self.linechatset.PointColor;
//        //        [self addSubview:button];
//        //        
//        //        [buttons addObject:button];
//    }
//    CGContextRestoreGState(ctx);

    
    self.curveshapeLayer.frame = self.bounds;
    self.curveshapeLayer.strokeColor = self.linechatset.CurveColor.CGColor;
    self.curveshapeLayer.lineWidth = 2;
    self.curveshapeLayer.path = [self graphPathFromPoints].CGPath;
    self.curveshapeLayer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.curveshapeLayer.shadowOffset = CGSizeMake(4, 0);
    self.curveshapeLayer.shadowRadius = 1.0;
    self.curveshapeLayer.shadowOpacity = 0.8;
    
    if (self.remainbtn != nil) {
        [self.remainbtn removeFromSuperview];
    }
    if (self.showdowView != nil) {
        [self.showdowView removeFromSuperview];
    }
    if (self.self.indexView != nil) {
        [self.indexView removeFromSuperview];
    }
    if (self.indexPointButton != nil) {
        [self.indexPointButton removeFromSuperview];
    }
    UIView* showdowView = [[UIView alloc] init];
    self.showdowView.userInteractionEnabled = NO;
    showdowView.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.25];
    showdowView.alpha = 0.25;
//    showdowView.backgroundColor = [UIColor yellowColor];
    showdowView.hidden = YES;
    self.showdowView = showdowView;
    [self addSubview:showdowView];
    
    
    UILabel* indexView = [[UILabel alloc] init];
    self.indexView = indexView;
    self.indexView.hidden = YES;
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.remainbtn = button;
//    self.remainbtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//    [button setTitleColor:self.linechatset.ReminderColor forState:UIControlStateNormal];  //self.linechatset.ReminderColor
//    [self updateRemainBtn];
//    button.hidden = YES;
    [self addSubview:indexView];
}

#pragma mark - 手势的添加
- (void)createPinchGesture
{
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] init];
    [pinchGes addTarget:self action:@selector(pinchGes:)];
    [self addGestureRecognizer:pinchGes];
}

#pragma mark - 手势部分的处理
- (void)pinchGes:(UIPinchGestureRecognizer *)ges
{
    //取到缩放手势中，当前的缩放比例 获取当前手势的位置
    CGFloat scale = ges.scale;
    if (ges.state == UIGestureRecognizerStateBegan) {
        point =  [ges locationInView:self];
    }
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        if ((xstep*scale > MINSTEP) && (xstep*scale < MAXSTEP)) {
            xstep *= scale;
            if (xstep * self.xarray.count + xleft + 20 > self.linechatset.mysrcW) {
                self.bounds = CGRectMake(0, 0, xstep * self.xarray.count + xleft + 20, self.bounds.size.height);
            }
            CGFloat scr = point.x * scale;
            if ([self.delegate respondsToSelector:@selector(LinechartBasicView:width:Scroll:)]) {
                [self.delegate LinechartBasicView:self width:xstep * self.xarray.count + xleft Scroll:scr];
            }
        }
        //每次缩放后都应该将scale设为1，让缩放手势和缩放比例根据当前缩放后的位置去计算
        ges.scale = 1;
    }
}

//增加点击手势
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 1.获得当前的触摸点
    UITouch *touch = [touches anyObject];
    if (touch.view == self.showdowView) {
        return;
    }
    CGPoint startPos = [touch locationInView:touch.view];
    
    int localx = startPos.x - xleft;
    int x = (localx / xstep);
    
    if (x < self.yarray.count) {
        index = x;
        [self updateRemainBtn];
    }
}

#pragma mark - 工具类
-(NSMutableDictionary *) getAttributesWithfont:(UIFont*)font Color:(UIColor*) color{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = color;
    attrs[NSFontAttributeName] = font;
    return attrs;
}

void drawArc(int x, int y, int r)
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddArc(ctx, x, y, r, 0, 2*M_PI, 0);
    CGContextFillPath(ctx);
}

#pragma mark - 从点里面获取路径
- (UIBezierPath *)graphPathFromPoints{
    UIBezierPath *path=[UIBezierPath bezierPath];
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    
    //先连线
    CGFloat ypixunit = (myH - ybottom - ytop) / (self.linechatset.ytotal - self.linechatset.ybasic);
    for (int z = 0; z < self.xarray.count; z++) {
        NSNumber *num = self.yarray[z];
        CGFloat ypoint0 =  myH - (ybottom + ([num intValue] - self.linechatset.ybasic) * ypixunit);
        CGPoint temppoint = CGPointMake(xleft + z*xstep, ypoint0);
        if(z == 0)
        {
            [path moveToPoint:temppoint];
        }else{
            [path addLineToPoint:temppoint];
        }
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius=3;
        button.frame=CGRectMake(0, 0, 6, 6);
        button.center = temppoint;
        button.tag = z;
        button.backgroundColor = self.linechatset.PointColor;
        [self addSubview:button];
        
        [buttons addObject:button];
    }
    
    if (curved) {
        path=[path smoothedPathWithGranularity:self.yarray.count];
    }
    
    path.lineWidth = 8;
    return path;
}


- (void)animate{
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    self.curveshapeLayer.path = [self graphPathFromPoints].CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 3.0;
    animation.delegate= nil;
    [self.curveshapeLayer addAnimation:animation forKey:@"MPStroke"];
    
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    CGFloat ypixunit = (myH - ybottom - ytop) / (self.linechatset.ytotal - self.linechatset.ybasic);
    for (int z = 0; z < self.xarray.count; z++) {
        NSNumber *num = self.yarray[z];
        CGFloat ypoint0 =  myH - (ybottom + ([num intValue] - self.linechatset.ybasic) * ypixunit);
        CGPoint temppoint = CGPointMake(xleft + z*xstep, ypoint0);
       
        
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius=3;
        button.frame=CGRectMake(0, 0, 6, 6);
        button.center = temppoint;
        button.tag = z;
        button.backgroundColor = self.linechatset.PointColor;
        button.transform=CGAffineTransformMakeScale(0,0);
        [self addSubview:button];

        CGFloat delay=((CGFloat)3.0)/(CGFloat)self.yarray.count;
        [self performSelector:@selector(displayPoint:) withObject:button afterDelay:delay*z];
        [buttons addObject:button];
    }
}

- (void)displayPoint:(UIButton *)button{
    [UIView animateWithDuration:.2 animations:^{
        button.transform=CGAffineTransformMakeScale(1, 1);
    }];
}

-(void) updateRemainBtn{
    NSNumber *num0 = self.yarray[index];
    if ([num0 isEqualToNumber:NAValidNum]) {
        return;    //不做处理
    }
    NSString *string = [NSString stringWithFormat:@"%d",[num0 intValue]];
    CGFloat ypixunit = (myH - ybottom - ytop) / (self.linechatset.ytotal - self.linechatset.ybasic);
    CGFloat ypoint0 =  myH - (ybottom + ([num0 intValue] - self.linechatset.ybasic) * ypixunit);
    CGFloat remainH = 29.5;
    CGFloat remainW = 50;
    CGFloat remainX = (xleft + xstep * index - remainW/2);
    CGFloat remainY = ypoint0-21-pointR- 2-6;
    
    CGFloat maxY = (myH - ybottom);
    if(remainY > maxY){
        remainY = maxY;
    }
    
    CGFloat showW = 40.0;
    CGFloat showdowX = remainX + remainW/2 - showW/2;
    
    self.indexView.text = [NSString stringWithFormat:@"%d",[num0 intValue]];
    self.indexView.hidden = NO;
    self.indexView.frame = CGRectMake(showdowX, remainY, showW, remainH);
//    [self.remainbtn setBackgroundImage:[UIImage imageNamed:@"statistics_data_bg"] forState:UIControlStateNormal];
//    self.remainbtn.hidden = NO;
//    self.remainbtn.frame = CGRectMake(showdowX, remainY, showW, remainH);
//    [self.remainbtn setTitle:string forState:UIControlStateNormal];
    
    [self.indexPointButton removeFromSuperview];
    CGFloat centerY =  myH - (ybottom + ([num0 intValue]- self.linechatset.ybasic)* ypixunit);
    CGPoint temppoint = CGPointMake(xleft + index*xstep, centerY);
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius=3;
    button.frame=CGRectMake(0, 0, 6, 6);
    button.center = temppoint;
    button.backgroundColor = self.linechatset.PointColor;
    self.indexPointButton = button;
    [self addSubview:button];
    
    //设置layer的位置
    self.showdowView.hidden = NO;
    self.showdowView.frame = CGRectMake(showdowX, 0, showW, self.height);
}





@end

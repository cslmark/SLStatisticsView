//
//  ColumnChartBasicView.m
//  IOS统计图标
//
//  Created by smart on 16/1/5.
//  Copyright © 2016年 smart. All rights reserved.
//

#import "ColumnChartBasicView.h"
#import "statisticsSet.h"
#import "UIBezierPath+curved.h"
#import "UIView+Frame.h"

/*****************门限制定*********************/
#define     MAXSTEP             320
#define     MINSTEP             1

@interface ColumnChartBasicView()
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
    
    NSMutableArray *buttons;
}
@property (nonatomic, weak) UIButton* remainbtn;
@end

@implementation ColumnChartBasicView

/**
 *  提供一个对外建立视图的方法
 */
+(ColumnChartBasicView*)buitStatisticsWithstatisticsSet:(statisticsSet*) linechatset{
    ColumnChartBasicView* view = [[ColumnChartBasicView alloc]init];
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
    self.clipsToBounds = YES;
    
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
    [self setNeedsDisplay];
}

#pragma mark - 作图部分
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    //保存宽高
    myW = rect.size.width;
    myH = rect.size.height;
    
    //        //先画背景
    //        [[UIColor whiteColor] set];
    //        CGContextAddRect(ctx, rect);
    //        CGContextFillPath(ctx);
    
    ////    背景图片
    ////    画背景图案
    //        UIImage *bgImage = [UIImage imageNamed:Picname];
    //        [bgImage drawInRect:rect];
    
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
    
    [self addBarsAnimated:_shouldAnimate];
    
    if (self.remainbtn != nil) {
        [self.remainbtn removeFromSuperview];
    }
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.remainbtn = button;
    [button setTitleColor:self.linechatset.ReminderColor forState:UIControlStateNormal];  //self.linechatset.ReminderColor
    [self updateRemainBtn];
    button.hidden = YES;
    [self addSubview:button];
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
            if ([self.delegate respondsToSelector:@selector(ColumnChartBasicView:width:Scroll:)]) {
                [self.delegate ColumnChartBasicView:self width:xstep * self.xarray.count + xleft Scroll:scr];
            }
        }
        //    每次缩放后都应该将scale设为1，让缩放手势和缩放比例根据当前缩放后的位置去计算
        ges.scale = 1;
    }
}

//增加点击手势
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 1.获得当前的触摸点
    UITouch *touch = [touches anyObject];
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


- (void)addBarsAnimated:(BOOL)animated{
    for (UIButton* button in buttons) {
        [button removeFromSuperview];
    }
    
    buttons=[[NSMutableArray alloc] init];
    if (animated) {
        self.layer.masksToBounds=YES;
    }
    
    CGFloat xpointW = xstep/2;
    CGFloat barWidth= xpointW;
    CGFloat radius=barWidth*(0.2);
    
    CGFloat ypixunit = (myH - ybottom - ytop) / (self.linechatset.ytotal - self.linechatset.ybasic);
    for (int z = 0; z < self.xarray.count; z++) {
        NSNumber *num = self.yarray[z];
        CGFloat validNum = ([num intValue]- self.linechatset.ybasic);
        CGFloat ypoint0 =  myH - (ybottom + validNum * ypixunit);
        CGFloat xpoint0 = (z * xstep) - xstep/4 + xleft;   //保证在中心
        CGFloat xpointH = [num intValue] * ypixunit;
        CGFloat xpointW = xstep/2;
        CGRect columnrectold = CGRectMake(xpoint0, self.height, xpointW, xpointH);
        CGRect columnrect = CGRectMake(xpoint0, ypoint0, xpointW, xpointH);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (animated) {
            button.frame = columnrectold;
        }else{
            button.frame = columnrect;
        }
        
        button.tag = z;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        //柱状图上面的圆角
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = button.bounds;
        if ([num intValue] >= 0) {
            maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)].CGPath;
        }else{
           maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)].CGPath;
        }
        button.layer.mask=maskLayer;
        button.layer.masksToBounds = YES;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = button.bounds;
        [button.layer addSublayer:gradientLayer];
        gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                                 (__bridge id)[UIColor blueColor].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        
        button.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:button];
        
        if (animated) {
            button.frame = CGRectMake(xpoint0, ypoint0+xpointH, xpointW, 0);
            [UIView animateWithDuration:2.0 delay:z*0.1 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                button.frame = columnrect;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:.15 animations:^{
                    button.frame = columnrect;
                }];
            }];
//            [UIView animateWithDuration:2.0 delay:z*0.1 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//                button.frame = columnrect;
//            }completion:^(BOOL finished) {
//                [UIView animateWithDuration:.15 animations:^{
//                    button.frame = columnrect;
//                }];
//            }];
        }
        [buttons addObject:button];
    }
    _shouldAnimate = NO;
}

-(void) click:(UIButton *) button{
    index = (int)button.tag;
    [self updateRemainBtn];
}

- (void)animate{
    _shouldAnimate = YES;
    [self setNeedsDisplay];
}

-(void) updateRemainBtn{
    NSNumber *num0 = self.yarray[index];
    NSString *string = [NSString stringWithFormat:@"%d",[num0 intValue]];
    CGFloat validNum = ([num0 intValue]- self.linechatset.ybasic);
    CGFloat ypixunit = (myH - ybottom - ytop) / self.linechatset.ytotal;
    CGFloat ypoint0 =  myH - (ybottom + validNum * ypixunit);
    CGFloat remainH = pointR*2;
    CGFloat remainW = 100;
    CGFloat remainX = (xleft + xstep * index - remainW/2);
    CGFloat remainY = ypoint0-21-pointR- 2;
    if ([num0 intValue] >= 0) {
        remainY = ypoint0-21-pointR- 2;
    }else{
        remainY = ypoint0+21+pointR+2;
    }
    
    CGFloat maxY = (myH - ybottom);
    CGFloat minY = ytop;
    if ((remainY- remainH) <= minY) {
        remainY = minY + remainH;
    }else if(remainY > maxY){
        remainY = maxY;
    }
    
    self.remainbtn.hidden = NO;
    self.remainbtn.frame = CGRectMake(remainX, remainY, remainW, remainH);
    [self.remainbtn setTitle:string forState:UIControlStateNormal];
}




@end

//
//  LinechartBasicView.h
//  IOS统计图标
//
//  Created by smart on 16/1/5.
//  Copyright © 2016年 smart. All rights reserved.
//

#import <UIKit/UIKit.h>
#define   NAValidNum    @(255)

@class statisticsSet, LinechartBasicView;

@protocol LinechartBasicViewDelegate <NSObject>
@optional
//因为手势的原因导致控件距离的改变的代理
-(void) LinechartBasicView:(LinechartBasicView*) view width:(CGFloat) width Scroll:(CGFloat) scr;
@end

@interface LinechartBasicView : UIControl
@property (nonatomic, strong) statisticsSet* linechatset;
@property (nonatomic, strong) NSMutableArray* yarray;
@property (nonatomic, strong) NSMutableArray* xarray;
@property (nonatomic, weak) id<LinechartBasicViewDelegate> delegate;

- (void)animate;
+(LinechartBasicView*)buitStatisticsWithstatisticsSet:(statisticsSet*) linechatset;
@end

/**
 *  使用注意事项
 *  1.其中xarray可以是任何对象,坐标轴将会显示的是 [self description]方法的字符串
 *  2.但是关于yarray自能是NSnumber的对象,该视图处理中默认将其作为NSNumber对象来处理
 */

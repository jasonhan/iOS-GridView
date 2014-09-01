//
//  WaterFallView.h
//  BrowserDemo
//
//  Created by iMac on 7/30/14.
//  Copyright (c) 2014 KLStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFallViewCell.h"
#import "SystemUtils.h"
#import "ImageCache.h"

@protocol WaterFallViewDelegate;

@interface WaterFallView : UIScrollView<UIScrollViewDelegate>

@property (assign,nonatomic) int column;

@property (nonatomic, strong) NSMutableArray        *visibleCells;                   //可见的cell
@property (weak,nonatomic) id<WaterFallViewDelegate> waterfallDelegate;              //代理
@property (assign,nonatomic) float velocity;                                         //每次触发scrollViewDidScroll时的偏移量

- (id)initWithFrame:(CGRect)frame andColumn:(int)column andDelegate:(id<WaterFallViewDelegate>) waterfallDelegate; //初始化
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(WaterFallIndex *)indexPath;           //返回一个可复用的cell
- (void)reloadData;                                                                                                //重新加载数据(只对可视区域)

@end

/////////////////////////////////////////////////////////////
//delegate of WaterFallView//
@protocol WaterFallViewDelegate<NSObject>

@required
- (WaterFallViewCell *)waterfallView:(WaterFallView *)waterfallView cellForRowAtIndexPath:(WaterFallIndex *)index; //获取WaterFallViewCell
- (NSInteger)numberOfCellsCount:(WaterFallView *)waterFallView;                                                    //WaterFallViewCell个数
- (float)heightOfCell;                                                                                             //cell的高度
- (float)gapWidth;                                                                                                 //两个cell之间的距离

@optional
- (void)waterfallViewDidEndDecelerating:(WaterFallView *)waterfallView;                                            //结束减速
- (void)waterfallViewWillBeginDecelerating:(WaterFallView *)waterfallView;                                                                                               //将要减速
- (void)waterfallViewDidEndDragging:(WaterFallView *)waterfallView willDecelerate:(BOOL)decelerate;

@end
//
//  WaterFallView.m
//  BrowserDemo
//
//  Created by iMac on 7/30/14.
//  Copyright (c) 2014 KLStudio. All rights reserved.
//

#import "WaterFallView.h"

@interface WaterFallView ()

@property (assign,nonatomic) float gapWidth;
@property (nonatomic, strong) NSMutableDictionary   *reuseDict;

- (void)initialize;
- (BOOL)cellShouldBeVisible:(CGRect)cellRect;
- (BOOL)containsVisibleCellForIndexPath:(WaterFallIndex *)indexPath;
- (void)addReusableCell:(WaterFallViewCell *)cell;
- (CGRect)rectForCellAtIndex:(int)indexPath;

@end

@implementation WaterFallView

- (id)initWithFrame:(CGRect)frame andColumn:(int)column andDelegate:(id<WaterFallViewDelegate>) waterfallDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate=self;
        self.waterfallDelegate=waterfallDelegate;
        self.column=column;
        self.gapWidth=[self.waterfallDelegate gapWidth];
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    if(self.column<=0) self.column=2;
    self.reuseDict=[[NSMutableDictionary alloc] init];
    self.visibleCells=[[NSMutableArray alloc] init];
    int cellsCount=[self.waterfallDelegate numberOfCellsCount:self];
    
    //计算contentSize
    CGFloat totalHeight=([self.waterfallDelegate heightOfCell]+self.gapWidth)*((int)((cellsCount-1)/self.column)+1);
    self.contentSize = CGSizeMake(self.frame.size.width, totalHeight);
    
    CGFloat visibleHeight=0.0f;
    
    //初始化能看见的几个块
    for (int i=0; i<cellsCount; i++) {
        WaterFallIndex *index=[[WaterFallIndex alloc] init];
        index.column=i%self.column;
        index.row=i/self.column;
        WaterFallViewCell *cell=[self.waterfallDelegate waterfallView:self cellForRowAtIndexPath:index];
        cell.indexPath=index;
        cell.frame=[self rectForCellAtIndex:i];
        if((i+1)%self.column==0)
            visibleHeight+=([self.waterfallDelegate heightOfCell]+self.gapWidth);
        
        if(cell.superview==nil)
            [self addSubview:cell];
        [self.visibleCells addObject:cell];
        
        if (visibleHeight>self.frame.size.height) {
            NSLog(@"break   %d",i);
            break;
        }
    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float oldY=0;
    
    //NSLog(@"%f",scrollView.contentOffset.y-oldY);
    self.velocity=scrollView.contentOffset.y-oldY;
    BOOL scrollUp=self.velocity>0?true:false;
    
    oldY=scrollView.contentOffset.y;
    
    WaterFallViewCell *lastCell=nil;
    
    
    //scrollUp时显示新的块
    if(scrollUp)
    {
        lastCell=[self.visibleCells lastObject];//获取可见cell中的最后一个
        int cellIndex=lastCell.indexPath.row*self.column+lastCell.indexPath.column;
        
        //从最后一个可见cell的位置往后扫描
        //如果发现有新的cell需要被显示，则调用delegate中的waterfallView:cellForRowAtIndexPath来得到这个新cell
        //然后把它加入到visibleCells中并加入view中显示
        //一直扫描到出现了不该出现新cell的位置
        for (int i=cellIndex+1; i<[self.waterfallDelegate numberOfCellsCount:self]; i++) {
            WaterFallIndex *index=[WaterFallIndex indexForColumn:i%self.column andRow:i/self.column];
            if ([self cellShouldBeVisible:[self rectForCellAtIndex:i]]) {
                if (![self containsVisibleCellForIndexPath:index]) {
                    WaterFallViewCell *cell=[self.waterfallDelegate waterfallView:self cellForRowAtIndexPath:index];
                    cell.indexPath=index;
                    cell.frame=[self rectForCellAtIndex:i];
                    
                    if(cell.superview==nil) [self addSubview:cell];
                    [self.visibleCells addObject:cell];
                }
            }
            else break;
        }
    }
    else//scrollDown时显示新的块
    {
        //lastCell=[self.visibleCells lastObject];
        lastCell=[self.visibleCells objectAtIndex:0];
        int cellIndex=lastCell.indexPath.row*self.column+lastCell.indexPath.column;
        //NSLog(@"%d",cellIndex);
        for (int i=cellIndex-1; i>=0; i--) {
            WaterFallIndex *index=[WaterFallIndex indexForColumn:i%self.column andRow:i/self.column];
            if ([self cellShouldBeVisible:[self rectForCellAtIndex:i]]) {
                if (![self containsVisibleCellForIndexPath:index]) {
                    WaterFallViewCell *cell=[self.waterfallDelegate waterfallView:self cellForRowAtIndexPath:index];
                    cell.indexPath=index;
                    cell.frame=[self rectForCellAtIndex:i];
                    
                    if(cell.superview==nil) [self addSubview:cell];
                    //[self.visibleCells addObject:cell];
                    [self.visibleCells insertObject:cell atIndex:0];
                }
                
            }
            else break;
        }
    }
    
    //清理看不见的块
    for (int i=0; i<self.visibleCells.count; i++) {
        WaterFallViewCell *cell=[self.visibleCells objectAtIndex:i];
        if ([self cellShouldBeVisible:cell.frame]) {
            continue;
        }
        [cell removeFromSuperview];
        [self addReusableCell:cell];
        [self.visibleCells removeObject:cell];
        i--;
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.waterfallDelegate!=nil&&[self.waterfallDelegate respondsToSelector:@selector(waterfallViewDidEndDecelerating:)]) {
        [self.waterfallDelegate waterfallViewDidEndDecelerating:self];
    }
    //[self reloadData];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (self.waterfallDelegate!=nil&&[self.waterfallDelegate respondsToSelector:@selector(waterfallViewWillBeginDecelerating:)]) {
        [self.waterfallDelegate waterfallViewWillBeginDecelerating:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.waterfallDelegate!=nil&&[self.waterfallDelegate respondsToSelector:@selector(waterfallViewDidEndDragging:willDecelerate:)]) {
        [self.waterfallDelegate waterfallViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (BOOL)cellShouldBeVisible:(CGRect)cellRect
{
    CGPoint offset = [self contentOffset];
    
    if (cellRect.origin.y + cellRect.size.height < offset.y
        || cellRect.origin.y > (offset.y + self.frame.size.height)) {
        return NO;
    }
    
    return YES;
}

- (BOOL)containsVisibleCellForIndexPath:(WaterFallIndex *)indexPath
{
    for (int i = 0; i < [self.visibleCells count]; ++i) {
        WaterFallViewCell *cell = [self.visibleCells objectAtIndex:i];
        if (cell.indexPath.row == indexPath.row && cell.indexPath.column == indexPath.column) {
        
            return YES;
        }
    }
    return NO;
}

- (void)addReusableCell:(WaterFallViewCell *)cell
{
    if (nil == cell.reuseIdentifier || 0 == cell.reuseIdentifier.length) {
        return ;
    }
    
    NSMutableArray *reuseQueue = [self.reuseDict objectForKey:cell.reuseIdentifier];
    
    if(nil == reuseQueue) {
        reuseQueue = [NSMutableArray arrayWithObject:cell];
        [self.reuseDict setObject:reuseQueue forKey:cell.reuseIdentifier];
    } else {
        [reuseQueue addObject:cell];
    }
}

- (CGRect) rectForCellAtIndex:(int)indexPath
{
    int row=indexPath/self.column;
    int column=indexPath%self.column;
    
    CGFloat x=self.gapWidth/2+320/self.column*column;
    CGFloat y=([self.waterfallDelegate heightOfCell]+self.gapWidth)*row;
    CGFloat width=320/self.column-self.gapWidth;
    CGFloat height=[self.waterfallDelegate heightOfCell];
    
    CGRect rect=CGRectMake(x, y, width, height);
    return  rect;
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(WaterFallIndex *)indexPath
{
    if (nil == identifier || 0 == identifier.length)
    {
        return nil;
    }
    
    //如果该cell是在可视区域内，则直接返回它
    if ([self containsVisibleCellForIndexPath:indexPath]) {
        for (int i=0; i<self.visibleCells.count; i++) {
            WaterFallViewCell *cell=[self.visibleCells objectAtIndex:i];
            if (cell.indexPath.row==cell.indexPath.row&&cell.indexPath.column==cell.indexPath.column) {
                return cell;
            }
        }
    }
    
    NSMutableArray *reuseQueue = [self.reuseDict objectForKey:identifier];
	if(reuseQueue && [reuseQueue isKindOfClass:[NSArray class]] && reuseQueue.count > 0) {
		WaterFallViewCell *cell = [reuseQueue lastObject];
        [reuseQueue removeLastObject];
		return cell;
	}
    
    return nil;

}

- (void)reloadData
{
    for (int i=0; i<self.visibleCells.count; i++) {
        WaterFallViewCell *visibleCell=[self.visibleCells objectAtIndex:i];
        [self.waterfallDelegate waterfallView:self cellForRowAtIndexPath:visibleCell.indexPath];
    }
}

@end

//
//  WaterFallIndex.m
//  BrowserDemo
//
//  Created by iMac on 7/30/14.
//  Copyright (c) 2014 KLStudio. All rights reserved.
//

#import "WaterFallIndex.h"

@implementation WaterFallIndex

+ (WaterFallIndex *)indexForColumn:(int)column andRow:(int)row
{
    WaterFallIndex *index=[[WaterFallIndex alloc] init];
    index.column=column;
    index.row=row;
    return index;
}

@end

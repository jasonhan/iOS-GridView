//
//  WaterFallIndex.h
//  BrowserDemo
//
//  Created by iMac on 7/30/14.
//  Copyright (c) 2014 KLStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaterFallIndex : NSObject

@property (assign,nonatomic) int column;
@property (assign,nonatomic) int row;

+ (WaterFallIndex *)indexForColumn:(int)column andRow:(int)row;

@end

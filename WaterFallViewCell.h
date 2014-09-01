//
//  WaterFallViewCell.h
//  BrowserDemo
//
//  Created by iMac on 7/30/14.
//  Copyright (c) 2014 KLStudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterFallIndex.h"

@interface WaterFallViewCell : UIView

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (nonatomic, strong) WaterFallIndex *indexPath;

- (id)initWithIdentifier:(NSString *)identifier andFrame:(CGRect)frame;

@end

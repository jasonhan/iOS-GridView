//
//  WaterFallViewCell.m
//  BrowserDemo
//
//  Created by iMac on 7/30/14.
//  Copyright (c) 2014 KLStudio. All rights reserved.
//

#import "WaterFallViewCell.h"

@implementation WaterFallViewCell

- (id)initWithIdentifier:(NSString *)identifier andFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.reuseIdentifier=identifier;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

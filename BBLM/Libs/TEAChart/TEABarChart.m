//
//  TEABarChart.m
//  Xhacker
//
//  Created by Xhacker on 2013-07-25.
//  Copyright (c) 2013 Xhacker. All rights reserved.
//

#import "TEABarChart.h"

@implementation TEABarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        [self loadDefaults];
    }
    return self;
}

- (void)loadDefaults
{
    self.opaque = NO;

    _xLabels = nil;

    _autoMax = YES;

    _barColor = [UIColor colorWithRed:106.0/255 green:175.0/255 blue:232.0/255 alpha:1];
    _barSpacing = 8;
    _backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];
    _roundToPixel = YES;
}

- (void)prepareForInterfaceBuilder
{
    [self loadDefaults];
    
    self.data = @[@3, @1, @4, @1, @5, @9, @2, @6];
    self.xLabels = @[@"T", @"E", @"A", @"C", @"h", @"a", @"r", @"t"];
}

- (void)drawRect:(CGRect)rect
{    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    double max = self.autoMax ? [[self.data valueForKeyPath:@"@max.self"] doubleValue] : self.max;
    CGFloat barMaxHeight = CGRectGetHeight(rect);
    NSInteger numberOfBars = self.data.count;
    CGFloat barWidth = (CGRectGetWidth(rect) - self.barSpacing * (numberOfBars - 1)) / numberOfBars;
    CGFloat barWidthRounded = ceil(barWidth);

    if (self.xLabels) {
        CGFloat fontSize = floor(barWidth);
        CGFloat labelsTopMargin = ceil(fontSize * 0.33);
        barMaxHeight -= (fontSize + labelsTopMargin);

        [self.xLabels enumerateObjectsUsingBlock:^(NSString *label, NSUInteger idx, BOOL *stop) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            
            _textColor = (_textColor ? _textColor:  [UIColor colorWithWhite:0.56 alpha:1]);
        
            [label drawInRect:CGRectMake(idx * (barWidth + self.barSpacing), barMaxHeight + labelsTopMargin, barWidth, fontSize * 1.2)
               withAttributes:@{
                                NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize],
                                NSForegroundColorAttributeName: _textColor,
                                NSParagraphStyleAttributeName:paragraphStyle,
                                }];
        }];
    }

    for (NSInteger i = 0; i < numberOfBars; i += 1)
    {
        CGFloat barHeight = (max == 0 ? 0 : barMaxHeight * [self.data[i] floatValue] / max);
        if (barHeight > barMaxHeight) {
            barHeight = barMaxHeight;
        }
        if (self.roundToPixel) {
            barHeight = (int)barHeight;
        }
        
        CGFloat x = floor(i * (barWidth + self.barSpacing));
      
        [self.backgroundColor setFill];
        CGRect backgroundRect = CGRectMake(x, 0, barWidthRounded, barMaxHeight);
        CGContextFillRect(context, backgroundRect);
        
        CGFloat width = barWidthRounded;
        CGFloat height = barHeight;
        
        CGFloat y = barMaxHeight - barHeight;
        // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
        CGFloat radius = _cornerRadius;
        
        // 获取CGContext，注意UIKit里用的是一个专门的函数
        CGContextRef context = UIGraphicsGetCurrentContext();
        // 移动到初始点
        CGContextMoveToPoint(context, x+radius, y);
        
        // 绘制第1条线和第1个1/4圆弧
        CGContextAddLineToPoint(context, x + width - radius, y);
        CGContextAddArc(context, x + width - radius, y + radius, radius, -0.5 * M_PI, 0.0, 0);
        
        // 绘制第2条线和第2个1/4圆弧
        CGContextAddLineToPoint(context, x + width, y + height - radius);
        CGContextAddArc(context, x + width - radius, y + height - radius, radius, 0.0, 0.5 * M_PI, 0);
        
        // 绘制第3条线和第3个1/4圆弧
        CGContextAddLineToPoint(context, x + radius, y + height);
        CGContextAddArc(context, x + radius, y + height - radius, radius, 0.5 * M_PI, M_PI, 0);
        
        // 绘制第4条线和第4个1/4圆弧
        CGContextAddLineToPoint(context,x, y + radius);
        CGContextAddArc(context, x + radius, y + radius, radius, M_PI, 1.5 * M_PI, 0);
        
        // 闭合路径
        CGContextClosePath(context);
        // 填充半透明黑色
        
        CGFloat r, g, b, a;
        [_barColor getRed: &r green:&g blue:&b alpha:&a];
        CGContextSetRGBFillColor(context, r, g, b, a);
        CGContextDrawPath(context, kCGPathFill);


//        CGContextFillRect(context, barRect);
    }
}

#pragma mark Setters

- (void)setData:(NSArray *)data
{
    _data = data;
    [self setNeedsDisplay];
}

- (void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    [self setNeedsDisplay];
}

- (void)setMax:(CGFloat)max
{
    _max = max;
    [self setNeedsDisplay];
}

- (void)setAutoMax:(BOOL)autoMax
{
    _autoMax = autoMax;
    [self setNeedsDisplay];
}

- (void)setBarColors:(NSArray *)barColors
{
    _barColors = barColors;
    [self setNeedsDisplay];
}

- (void)setBarColor:(UIColor *)barColor
{
    _barColor = barColor;
    [self setNeedsDisplay];
}

- (void)setBarSpacing:(NSInteger)barSpacing
{
    _barSpacing = barSpacing;
    [self setNeedsDisplay];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}


@end

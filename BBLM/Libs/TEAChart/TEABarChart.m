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
}

- (void)drawRect:(CGRect)rect
{    
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    double max = self.autoMax ? [[self.data valueForKeyPath:@"@max.self"] doubleValue] : self.max;
    CGFloat barMaxHeight = CGRectGetHeight(rect);
    NSInteger numberOfBars = self.data.count;
    
    CGFloat barWidth = 12;
    CGFloat fontSize = 12;
    if (kWindowWidth == 320) {
        barWidth = 12;
        fontSize = 11;
    }
    
    barMaxHeight -= (40+20);

    _barSpacing = (float)(rect.size.width-barWidth*_xLabels.count-30)/(_xLabels.count-1);
    CGFloat barWidthRounded = ceil(barWidth);
    

    if (self.xLabels) {

        [self.xLabels enumerateObjectsUsingBlock:^(NSString *label, NSUInteger idx, BOOL *stop) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
            
            _textColor = (_textColor ? _textColor:  [UIColor colorWithWhite:0.56 alpha:1]);
            NSMutableString *text = [[NSMutableString alloc] init];
            switch (idx+1) {
                case 1:
                    [text appendString:@"一\n"];
                    break;
                case 2:
                    [text appendString:@"二\n"];
                    break;
                case 3:
                    [text appendString:@"三\n"];
                    break;
                case 4:
                    [text appendString:@"四\n"];
                    break;
                case 5:
                    [text appendString:@"五\n"];
                    break;
                case 6:
                    [text appendString:@"六\n"];
                    break;
                case 7:
                    [text appendString:@"日\n"];
                    break;
                
                default:
                    break;
            }
            if ([label containsString:@"上周"]) {
                [text appendString:@"上周"];
            } else {
                [text appendString:@"本周"];
            }
        
            
            [text drawInRect:CGRectMake(idx * (barWidth + self.barSpacing), barMaxHeight+20+10, barWidth+30, 30)
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
        if (barHeight < 0) {
            barHeight = 0;
        }
        if (self.roundToPixel) {
            barHeight = (int)barHeight;
        }
        
        CGFloat x = floor(i * (barWidth + self.barSpacing))+15;
        
        [self.backgroundColor setFill];
        CGRect backgroundRect = CGRectMake(x, 0, barWidthRounded, barMaxHeight);
        CGContextFillRect(context, backgroundRect);
        CGFloat width = barWidthRounded;
        CGFloat height = barHeight;
        CGFloat y = barMaxHeight - barHeight + 20;

        if (barHeight != 0) {
            height += 5;
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

        }

        if ([[_data objectAtIndex:i] integerValue] > 0) {
            NSString *valueLabel = [NSString stringWithFormat:@"辣度%ld", [[_data objectAtIndex:i] integerValue]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
            paragraphStyle.alignment = NSTextAlignmentCenter;
            [valueLabel drawInRect:CGRectMake(x-15, y-20, width+30, 15)
                    withAttributes:@{
                                     NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:10],
                                     NSForegroundColorAttributeName: _textColor,
                                     NSParagraphStyleAttributeName:paragraphStyle,
                                     }];
        }
        
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

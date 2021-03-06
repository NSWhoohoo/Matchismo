//
//  SetPlayingCardView.m
//  machismo
//
//  Created by Appleseed on 8/26/14.
//  Copyright (c) 2014 Appleseed. All rights reserved.
//

#import "SetPlayingCardView.h"

@implementation SetPlayingCardView

#pragma mark - Property
-(void)setNumber:(int)number
{
    _number = number;
    [self setNeedsDisplay];
}

-(void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setShading:(NSString *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

-(void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    [self setNeedsDisplay];
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

#pragma mark - Drawing
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    if (self.chosen) {
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSaveGState(context);
//        [[UIColor blackColor] setStroke];
//        CGContextSetLineWidth(context, 10);
//        CGPathRef path = roundedRect.CGPath;
//        CGContextAddPath(context, path);
//        CGContextStrokePath(context);
//        CGContextRestoreGState(context);
        roundedRect.lineWidth = 10;
        [roundedRect stroke];
    }
    [self drawCardFace];
}


#define SYMBOL_OFFSET 0.2;
#define SYMBOL_LINE_WIDTH 0.02;

- (void)drawCardFace
{
    [[self uiColor] setStroke];
    CGPoint point = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    if (self.number == 1) {
        [self drawSymbolAtPoint:point];
        return;
    }
    CGFloat dx = self.bounds.size.width * SYMBOL_OFFSET;
    if (self.number == 2) {
        [self drawSymbolAtPoint:CGPointMake(point.x - dx / 2.0, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx / 2.0, point.y)];
        return;
    }
    if (self.number == 3) {
        [self drawSymbolAtPoint:point];
        [self drawSymbolAtPoint:CGPointMake(point.x - dx, point.y)];
        [self drawSymbolAtPoint:CGPointMake(point.x + dx, point.y)];
        return;
    }
}

- (UIColor *)uiColor
{
    if ([self.color isEqualToString:@"red"]) return [UIColor redColor];
    if ([self.color isEqualToString:@"green"]) return [UIColor greenColor];
    if ([self.color isEqualToString:@"purple"]) return [UIColor purpleColor];
    return nil;
}

- (void)drawSymbolAtPoint:(CGPoint)point
{
    if ([self.symbol isEqualToString:@"oval"]) [self drawOvalAtPoint:point];
    else if ([self.symbol isEqualToString:@"squiggle"]) [self drawSquiggleAtPoint:point];
    else if ([self.symbol isEqualToString:@"diamond"]) [self drawDiamondAtPoint:point];
}

#define OVAL_WIDTH 0.12
#define OVAL_HEIGHT 0.4

- (void)drawOvalAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * OVAL_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * OVAL_HEIGHT / 2.0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x - dx, point.y - dy, 2.0 * dx, 2.0 * dy)
                                                    cornerRadius:dx];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define SQUIGGLE_WIDTH 0.12
#define SQUIGGLE_HEIGHT 0.3
#define SQUIGGLE_FACTOR 0.8

- (void)drawSquiggleAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT / 2.0;
    CGFloat dsqx = dx * SQUIGGLE_FACTOR;
    CGFloat dsqy = dy * SQUIGGLE_FACTOR;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
    [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
                 controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
    [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
            controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
            controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
    [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
                 controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
    [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
            controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
            controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define DIAMOND_WIDTH 0.15
#define DIAMOND_HEIGHT 0.4

- (void)drawDiamondAtPoint:(CGPoint)point;
{
    CGFloat dx = self.bounds.size.width * DIAMOND_WIDTH / 2.0;
    CGFloat dy = self.bounds.size.height * DIAMOND_HEIGHT / 2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(point.x, point.y - dy)];
    [path addLineToPoint:CGPointMake(point.x + dx, point.y)];
    [path addLineToPoint:CGPointMake(point.x, point.y + dy)];
    [path addLineToPoint:CGPointMake(point.x - dx, point.y)];
    [path closePath];
    path.lineWidth = self.bounds.size.width * SYMBOL_LINE_WIDTH;
    [self shadePath:path];
    [path stroke];
}

#define STRIPES_OFFSET 0.06
#define STRIPES_ANGLE 5

- (void)shadePath:(UIBezierPath *)path
{
    if ([self.shading isEqualToString:@"solid"]) {
        [[self uiColor] setFill];
        [path fill];
    } else if ([self.shading isEqualToString:@"striped"]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [path addClip];
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        CGPoint start = self.bounds.origin;
        CGPoint end = start;
        CGFloat dy = self.bounds.size.height * STRIPES_OFFSET;
        end.x += self.bounds.size.width;
        start.y += dy * STRIPES_ANGLE;
        for (int i = 0; i < 1 / STRIPES_OFFSET; i++) {
            [stripes moveToPoint:start];
            [stripes addLineToPoint:end];
            start.y += dy;
            end.y += dy;
        }
        stripes.lineWidth = self.bounds.size.width / 2 * SYMBOL_LINE_WIDTH;
        [stripes stroke];
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    } else if ([self.shading isEqualToString:@"open"]) {
        [[UIColor clearColor] setFill];
    }
}

#pragma mark - Setup

- (void)setup
{
    self.opaque = NO;
    self.backgroundColor = nil;
    self.contentMode = UIViewContentModeRedraw;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

@end

//
//  Carousel.m
//  Carousel
//
//  Created by Sergey Yuzepovich on 09.12.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "Carousel.h"
#define SUBVIEW_SIZE   100

@implementation Carousel
{
    NSMutableArray *subviews;
    CGPoint panDistance;
    NSTimer *fadeTimer;
    NSUInteger fadeIteration;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        subviews = [[NSMutableArray alloc]init];
        
        [self insertView: [self createView] ];
        [self insertView: [self createView] ];
        [self insertView: [self createView] ];
        [self insertView: [self createView] ];
        [self insertView: [self createView] ];
        [self insertView: [self createView] ];
        [self insertView: [self createView] ];
        [self insertView: [self createView] ];
        [self insertView: [self createView] ];
        
        UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panned:)];
        [self addGestureRecognizer:panRec];
    }
    
    return self;
}

-(UIView*)createView
{
    static UIColor *c;
    if(c == nil)
    {
        c = [UIColor colorWithHue:0.1 saturation:1 brightness:1 alpha:1];
    }
    else
    {
        CGFloat hue;
        [c getHue:&hue saturation:nil brightness:nil alpha:nil];
        c = [UIColor colorWithHue:hue+0.1 saturation:1 brightness:1 alpha:1];
    }
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SUBVIEW_SIZE, SUBVIEW_SIZE)];
    [v setBackgroundColor:c];
    return v;
}

-(void)insertView:(UIView*)view
{
    [self addSubview:view];
    [subviews addObject:view];
}

-(void)layoutSubviews
{
    for ( int i=0; i<subviews.count; i++) {
        UIView* view = subviews[i];
        view.layer.transform = [self transformForViewAtIndex:i];;
    }
}

-(NSUInteger)count
{
    return [subviews count];
}

-(CATransform3D)transformForViewAtIndex:(NSUInteger)index
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -2.5 / 1000;
    transform = CATransform3DTranslate(transform,
                                       [self xTranslation:index],
                                       CGRectGetHeight([UIScreen mainScreen].bounds)/2 - SUBVIEW_SIZE/2,
                                       [self zTranslation:index]
                                       );
    return transform;
}

-(float)xTranslation:(NSUInteger)index
{
    float screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    float screenCenter = screenW / 2;
    float initialPhase = 2 * M_PI / [self count] * index;
    float panPhase = 2 * M_PI * panDistance.x / screenW * 2;
    
    return screenCenter + sinf(initialPhase + panPhase) * screenW/3 - SUBVIEW_SIZE/2;
}

-(float)zTranslation:(NSUInteger)index
{
    float screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    float initialPhase = 2 * M_PI / [self count] * index;
    float panPhase = 2 * M_PI * panDistance.x / screenW * 2;
    
    return cos(initialPhase + panPhase) * screenW/10;
}


-(void)panned:(UIPanGestureRecognizer*)pan
{
    static CGPoint panStart;
    
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        [self stopFading];
        
        panStart = panDistance;
    }
    
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        panDistance = CGPointMake(panStart.x + [pan translationInView:self].x, panStart.y + [pan translationInView:self].y);
        [self layoutSubviews];
    }
    
    if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint velocity = [pan velocityInView:self];
        
        fadeTimer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(panFade) userInfo:[NSValue valueWithCGPoint:velocity] repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:fadeTimer forMode:NSRunLoopCommonModes];
    }
}

-(void)panFade
{
    CGPoint velocity = [fadeTimer.userInfo CGPointValue];
    fadeIteration++;
    if(abs(velocity.x / 100 / fadeIteration) < 0.01)
    {
        [self stopFading];
    }
    else
    {
        panDistance.x += velocity.x / 100 / fadeIteration;
        panDistance.y += velocity.y / 100 / fadeIteration;
        [self layoutSubviews];
    }
}

-(void)stopFading
{
    fadeIteration=0;
    [fadeTimer invalidate];

}

@end

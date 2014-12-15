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
                                       CGRectGetHeight([UIScreen mainScreen].bounds)/2 - SUBVIEW_SIZE/2 ,
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
        panStart = [pan locationInView:self];
    }
    
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        [self layoutSubviews];
        CGPoint newDelta = CGPointMake([pan locationInView:self].x - panStart.x, [pan locationInView:self].y - panStart.y);
        panDistance = newDelta;//CGPointMake(panDistance.x + newDelta.x, panDistance.y + newDelta.y);
        /*[pan translationInView:self]*/
        //CGPointMake(panDistance.x + [pan translationInView:self].x, panDistance.y + [pan translationInView:self].y);
//        NSLog(@"%f %f", panDistance.x, panDistance.y);
        [self layoutSubviews];
    }
    
    if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint velocity = [pan velocityInView:self];
        NSLog(@"%f",velocity.x);
        
    }
}

@end

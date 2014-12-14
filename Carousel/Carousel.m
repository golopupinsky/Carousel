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
//        [self insertView: [self createView] ];
//        [self insertView: [self createView] ];
//        [self insertView: [self createView] ];
//        [self insertView: [self createView] ];
        
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
                                       /*[self panXtranslation:index] +*/ /*50 * index*/[self initialXtranslation:index],
                                       CGRectGetHeight([UIScreen mainScreen].bounds)/2 - SUBVIEW_SIZE/2 ,
                                       /*[self panZtranslation:index] +*/ /*500 - 50*index)*/ [self initialZtranslation:index]
                                       );
    return transform;
}

-(float)initialXtranslation:(NSUInteger)index
{
    float screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    return screenW / 2 + sinf(2*M_PI / [self count] * index + 2*M_PI*panDistance.x/screenW*2) * screenW/2 - SUBVIEW_SIZE/2 + 1 * index;
}

-(float)initialZtranslation:(NSUInteger)index
{
    float screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    return sin(2*M_PI / [self count] * index + 2*M_PI*panDistance.x/screenW) * screenW/2;
}

-(float)panXtranslation:(NSUInteger)index
{
    int screenW = CGRectGetWidth( [UIScreen mainScreen].bounds );
    return sinf(2*M_PI*panDistance.x/screenW*2) * screenW;
}

-(float)panZtranslation:(NSUInteger)index
{
    int screenW = CGRectGetWidth( [UIScreen mainScreen].bounds );
    return sin(2*M_PI*panDistance.x/screenW) * screenW/5;
}

-(void)panned:(UIPanGestureRecognizer*)pan
{
//    NSLog(@"Panned");
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        
    }
    
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        [self layoutSubviews];
        panDistance = [pan translationInView:self];//CGPointMake(panDistance.x + [pan translationInView:self].x, panDistance.y + [pan translationInView:self].y);
        NSLog(@"%f %f", panDistance.x, panDistance.y);
        [self layoutSubviews];
    }
    
    if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
        
    }
}

@end

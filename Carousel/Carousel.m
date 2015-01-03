//
//  Carousel.m
//  Carousel
//
//  Created by Sergey Yuzepovich on 09.12.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "Carousel.h"
#import <pop/POP.h>

#define SUBVIEW_SIZE   100
#define DECELERATE_ANIMATION_KEY @"decelerate"

@interface Carousel ()
@property (nonatomic)  CGPoint panDistance;
@end

@implementation Carousel
{
    NSMutableArray *subviews;
    POPAnimatableProperty *animatablePanDistance;
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
        
        animatablePanDistance =
        [POPAnimatableProperty propertyWithName:@"panDistance" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(Carousel *obj, CGFloat values[]) {
                values[0] = [obj panDistance].x;
                values[1] = [obj panDistance].y;
            };
            prop.writeBlock = ^(id obj, const CGFloat values[]) {
                [obj setPanDistance:CGPointMake(values[0],values[1])];
            };
        }];

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
    [super layoutSubviews];
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
    transform.m34 = -1.0 / 1000;
    float yTranslation = CGRectGetHeight([UIScreen mainScreen].bounds)/2 - SUBVIEW_SIZE/2;
    transform = CATransform3DTranslate(transform,
                                       [self xTranslation:index],
                                       yTranslation,
                                       [self zTranslation:index]
                                       );
    return transform;
}

-(float)xTranslation:(NSUInteger)index
{
    float screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    float screenCenter = screenW / 2;
    float initialPhase = 2 * M_PI / [self count] * index;
    float panPhase = 2 * M_PI * self.panDistance.x / screenW * 2;
    
    return screenCenter + sinf(initialPhase + panPhase) * screenW/3 - SUBVIEW_SIZE/2;
}

-(float)zTranslation:(NSUInteger)index
{
    float screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    float initialPhase = 2 * M_PI / [self count] * index;
    float panPhase = 2 * M_PI * self.panDistance.x / screenW * 2;
    
    return cosf(initialPhase + panPhase) * screenW/10;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self stopFading];
}

-(void)panned:(UIPanGestureRecognizer*)pan
{
    static CGPoint panStart;
    
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        panStart = self.panDistance;
    }
    
    if(pan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [pan translationInView:self];
        self.panDistance = CGPointMake(panStart.x + translation.x, panStart.y + translation.y);
    }
    
    if(pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled)
    {
        CGPoint velocity = [pan velocityInView:self];
        
        POPDecayAnimation *decayAnimation = [POPDecayAnimation animation];
        decayAnimation.property = animatablePanDistance;
        decayAnimation.velocity = [NSValue valueWithCGRect:CGRectMake(velocity.x, velocity.y, 0, 0)];
        [self pop_addAnimation:decayAnimation forKey:DECELERATE_ANIMATION_KEY];
    }
}

-(void)setPanDistance:(CGPoint)panDistance
{
    _panDistance = panDistance;
    [self layoutSubviews];
}

-(void)stopFading
{
    [self pop_removeAnimationForKey:DECELERATE_ANIMATION_KEY];
}

@end

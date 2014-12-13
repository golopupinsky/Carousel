//
//  Carousel.m
//  Carousel
//
//  Created by Sergey Yuzepovich on 09.12.14.
//  Copyright (c) 2014 Sergey Yuzepovich. All rights reserved.
//

#import "Carousel.h"

@implementation Carousel

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.delegate = self;
    }
    
    return self;
}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}


-(CATransform3D)transformForViewAtIndex:(NSUInteger)index
{
    return CATransform3DIdentity;
}


@end

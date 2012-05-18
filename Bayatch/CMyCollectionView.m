//
//  CMyCollectionView.m
//  Bayatch
//
//  Created by Jonathan Wight on 1/23/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CMyCollectionView.h"

#import <CoreServices/CoreServices.h>

@implementation CMyCollectionView

- (id)initWithCoder:(NSCoder *)inCoder
    {
    if ((self = [super initWithCoder:inCoder]) != NULL)
        {
        [self registerForDraggedTypes:[NSArray arrayWithObjects:(__bridge id)kUTTypeDirectory, (__bridge id)kUTTypeFolder, NULL]];
        NSLog(@"%@", self.registeredDraggedTypes);

        [self setDraggingSourceOperationMask:NSDragOperationEvery forLocal:YES];
        [self setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];

        }
    return(self);
    }
    
- (void)viewDidMoveToWindow
    {
    [super viewDidMoveToWindow];
    
    [self.enclosingScrollView registerForDraggedTypes:[NSArray arrayWithObjects:(__bridge id)kUTTypeDirectory, (__bridge id)kUTTypeFolder, NULL]];
    }

-(NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender
{
    return [self draggingEntered:sender];
}


@end

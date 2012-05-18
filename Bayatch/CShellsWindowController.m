//
//  CShellsWindowController.m
//  Bayatch
//
//  Created by Jonathan Wight on 1/23/12.
//  Copyright (c) 2012 toxicsoftware.com. All rights reserved.
//

#import "CShellsWindowController.h"

#import "CShellSession.h"
#import "CBlockValueTransformer.h"

@interface CShellsWindowController () <NSCollectionViewDelegate>
@property (readwrite, nonatomic, strong) NSArray *shellSessions;
@property (readwrite, nonatomic, strong) IBOutlet NSArrayController *sessionsController;
@property (readwrite, nonatomic, strong) NSString *script;
@end

#pragma mark -

@implementation CShellsWindowController

@synthesize shellSessions;
@synthesize sessionsController;
@synthesize script;

+ (void)initialize
    {
    [NSValueTransformer setValueTransformerForName:@"xyzzy" block:^id(id value)
        {
        if ([value intValue] == NO)
            {
            return([NSImage imageNamed:@"CellBackgroundDefault.png"]);
            }
        else
            {
            return([NSImage imageNamed:@"CellBackground.png"]);
            }
        }];
    }

- (id)initWithWindow:(NSWindow *)window
    {
    if ((self = [super initWithWindow:window]) != NULL)
        {
        }
    return(self);
    }

- (void)windowDidLoad
    {
    [super windowDidLoad];
    
    NSMutableArray *theDirectories = [NSMutableArray array];
    
    NSURL *theURL = [NSURL fileURLWithPath:@"/Users/schwa/Development/Source/Git/Projects/• Old"];
    NSError *theError = NULL;
    NSArray *theContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:theURL includingPropertiesForKeys:NULL options:NSDirectoryEnumerationSkipsHiddenFiles error:&theError];
    for (NSURL *theURL in theContents)
        {
        NSNumber *theFlag;
        [theURL getResourceValue:&theFlag forKey:NSURLIsDirectoryKey error:&theError];
        if (theFlag.boolValue == YES)
            {
            CShellSession *theSession = [[CShellSession alloc] initWithURL:theURL];
            [theDirectories addObject:theSession];
            }
        }

    self.shellSessions = [theDirectories copy];
    }

- (IBAction)runScript:(id)sender
    {
    NSLog(@"RUN SCRIPT: %@", self.script);

    for (CShellSession *theSession in self.sessionsController.selectedObjects)
        {
        [theSession runScript:self.script handler:NULL];
        }
    }

- (IBAction)add:(id)sender
    {
    NSOpenPanel *theOpenPanel = [NSOpenPanel openPanel];
    theOpenPanel.canChooseDirectories = YES;
    theOpenPanel.canChooseFiles = NO;
    theOpenPanel.allowsMultipleSelection = YES;
//    theOpenPanel.allowsOtherFileTypes
    
    [theOpenPanel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
            {
            for (NSURL *theURL in theOpenPanel.URLs)
                {
                CShellSession *theSession = [[CShellSession alloc] initWithURL:theURL];
                
                self.shellSessions = [self.shellSessions arrayByAddingObject:theSession];
                }


            }
        }];
    
    }


#pragma mark -

//- (NSDragOperation)collectionView:(NSCollectionView *)collectionView validateDrop:(id <NSDraggingInfo> )draggingInfo proposedIndex:(NSInteger *)proposedDropIndex dropOperation:(NSCollectionViewDropOperation *)proposedDropOperation
//    {
//    return(NSDragOperationCopy);
//    }
//    
//- (BOOL)collectionView:(NSCollectionView *)collectionView acceptDrop:(id <NSDraggingInfo> )draggingInfo index:(NSInteger)index dropOperation:(NSCollectionViewDropOperation)dropOperation
//    {
//    return(YES);
//    }
//
//- (BOOL)collectionView:(NSCollectionView *)collectionView canDragItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event
//    {
//    return(YES);
//    }
//    
//- (NSImage *)collectionView:(NSCollectionView *)collectionView draggingImageForItemsAtIndexes:(NSIndexSet *)indexes withEvent:(NSEvent *)event offset:(NSPointPointer)dragImageOffset
//    {
//    return(NULL);
//    }
//    
//- (NSArray *)collectionView:(NSCollectionView *)collectionView namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropURL forDraggedItemsAtIndexes:(NSIndexSet *)indexes
//    {
//    return(NULL);
//    }
//
//- (BOOL)collectionView:(NSCollectionView *)collectionView writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
//    {
//    return(YES);
//    }

@end
